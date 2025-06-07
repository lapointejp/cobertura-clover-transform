# -*- coding: utf-8 -*-

from __future__ import print_function

import lxml.etree as ET
import argparse
import importlib.resources


def convert(inxml):
    dom = ET.parse(inxml)
    with importlib.resources.files('cobertura_clover_transform').joinpath('transform.xslt').open('rb') as xslt_file:
        xslt = ET.parse(xslt_file)

    transform = ET.XSLT(xslt)
    newdom = transform(dom)
    return ET.tostring(newdom, pretty_print=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('coverage_xml')
    parser.add_argument('-o', '--output', required=False)
    args = parser.parse_args()

    converted = convert(args.coverage_xml)

    if args.output:
        with open(args.output, 'w') as out:
            out.write(converted.decode())
    else:
        print(converted)
