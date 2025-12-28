"""Apply an XSLT stylesheet to an XML file and write the result."""
import argparse
from pathlib import Path

from lxml import etree


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Apply an XSL stylesheet to an XML document."
    )
    parser.add_argument("xml", help="Input XML file path.")
    parser.add_argument("xsl", help="XSLT stylesheet file path.")
    parser.add_argument("output", help="Path to write the transformed result.")
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    xml_path = Path(args.xml)
    xsl_path = Path(args.xsl)
    out_path = Path(args.output)

    if not xml_path.is_file():
        raise SystemExit(f"XML file not found: {xml_path}")
    if not xsl_path.is_file():
        raise SystemExit(f"XSL file not found: {xsl_path}")

    xml_doc = etree.parse(str(xml_path))
    xslt_doc = etree.parse(str(xsl_path))
    transform = etree.XSLT(xslt_doc)
    result = transform(xml_doc)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    result.write_output(str(out_path))
    print(f"Generated {out_path} using {xsl_path.name}")


if __name__ == "__main__":
    main()
