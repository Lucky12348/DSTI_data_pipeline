"""
Validate operator.xml against operator.xsd and optionally apply an XSL stylesheet.

Usage examples:
  python validate_operator.py --xml operator.xml --xsd operator.xsd
  python validate_operator.py --xml operator.xml --xsd operator.xsd --xsl tour_catalog.xsl --out tour_catalog.html
  # for HTML/XML/JSON outputs alike
  python validate_operator.py --xml operator.xml --xsd operator.xsd --xsl bookings_json.xsl --out outputs/bookings.json
"""

import argparse
import sys
from pathlib import Path

import xmlschema
from lxml import etree


def validate(xml_path: Path, xsd_path: Path) -> None:
    schema = xmlschema.XMLSchema(xsd_path)
    schema.validate(xml_path)


def apply_xsl(xml_path: Path, xsl_path: Path, out_path: Path) -> None:
    xml_doc = etree.parse(str(xml_path))
    xsl_doc = etree.parse(str(xsl_path))
    transform = etree.XSLT(xsl_doc)
    result = transform(xml_doc)

    # str(result) respects the stylesheet output method (html/xml/text)
    content = str(result)
    out_path.write_bytes(content.encode("utf-8"))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Validate XML against XSD and optionally apply an XSL."
    )
    parser.add_argument(
        "--xml", default="operator.xml", type=Path, help="XML input file"
    )
    parser.add_argument(
        "--xsd", default="operator.xsd", type=Path, help="XSD schema file"
    )
    parser.add_argument("--xsl", type=Path, help="XSL stylesheet to apply")
    parser.add_argument(
        "--out", type=Path, help="Output path for the transformation result"
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    try:
        validate(args.xml, args.xsd)
        print(f"{args.xml} is valid against {args.xsd}")
    except xmlschema.XMLSchemaValidationError as exc:
        print(f"Validation failed: {exc}", file=sys.stderr)
        sys.exit(1)

    if args.xsl is None:
        return

    out_path = args.out or Path(args.xsl.stem).with_suffix(".out")
    apply_xsl(args.xml, args.xsl, out_path)
    print(f"Transformation written to {out_path}")


if __name__ == "__main__":
    main()
