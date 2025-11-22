"""
DOM-based implementation of the "facture client" scenario without XSLT.
Parses operator.xml, resolves references, and writes an HTML invoice per booking.

Usage:
  python invoice_dom.py --xml operator.xml --out outputs/invoice_dom.html
"""

import argparse
from pathlib import Path
from xml.dom import minidom


def _children(node, name):
    return [
        n for n in node.childNodes if n.nodeType == n.ELEMENT_NODE and n.tagName == name
    ]


def _text(node, name):
    elems = _children(node, name)
    if not elems:
        return ""
    texts = [t.data for t in elems[0].childNodes if t.nodeType == t.TEXT_NODE]
    return "".join(texts).strip()


def build_clients(doc):
    clients = {}
    for client in doc.getElementsByTagName("Client"):
        cid = client.getAttribute("id")
        clients[cid] = {
            "first": _text(client, "FirstName"),
            "last": _text(client, "LastName"),
            "email": _text(client, "Email"),
            "phone": _text(client, "Phone"),
        }
    return clients


def build_events(doc):
    """Return mapping of event_id -> context (event node, tour info, region info)."""
    mapping = {}
    for region in doc.getElementsByTagName("Region"):
        region_name = _text(region, "Name")
        region_country = _text(region, "Country")
        for tour in region.getElementsByTagName("Tour"):
            tour_title = _text(tour, "Title")
            tour_diff = _text(tour, "Difficulty")
            for event in tour.getElementsByTagName("TourEvent"):
                eid = event.getAttribute("id")
                mapping[eid] = {
                    "node": event,
                    "tour_title": tour_title,
                    "tour_diff": tour_diff,
                    "region": region_name,
                    "country": region_country,
                }
    return mapping


def gather_bookings(doc):
    bookings = doc.getElementsByTagName("Booking")
    return sorted(bookings, key=lambda b: _text(b, "BookingDate"))


def render_html(bookings, clients, events):
    lines = []
    append = lines.append
    append("<!DOCTYPE html>")
    append('<html><head><meta charset="UTF-8"><title>Factures DOM</title>')
    append(
        "<style>body{font-family:Segoe UI,sans-serif;background:#f7f7f9;padding:24px;color:#1f2933;}"
        ".card{background:#fff;border-radius:10px;box-shadow:0 4px 14px rgba(0,0,0,0.08);padding:16px;margin-bottom:16px;}"
        ".muted{color:#6b7280;} .total{font-weight:700;color:#0ea5e9;}</style>"
    )
    append("</head><body><h1>Invoices (DOM)</h1>")

    for booking in bookings:
        bid = booking.getAttribute("id")
        bdate = _text(booking, "BookingDate")
        client_ref = _text(booking, "ClientRef")
        event_ref = _text(booking, "EventRef")
        client = clients.get(client_ref, {})
        event_ctx = events.get(event_ref, {})
        amount_nodes = booking.getElementsByTagName("Amount")
        total = sum(float(a.firstChild.data) for a in amount_nodes if a.firstChild)
        currency = amount_nodes[0].getAttribute("currency") if amount_nodes else "EUR"

        append('<div class="card">')
        append(f'<div class="muted">Booking {bid} — {bdate}</div>')
        append(
            f'<div>Client: <strong>{client.get("first","")} {client.get("last","")}</strong> '
            f'— {client.get("email","")} — {client.get("phone","")}</div>'
        )
        append(
            f'<div>Tour: <strong>{event_ctx.get("tour_title","")}</strong> '
            f'({event_ctx.get("region","")} / {event_ctx.get("country","")}) '
            f'— Difficulty {event_ctx.get("tour_diff","")}</div>'
        )
        append(f'<div class="muted">Event: {event_ref}</div>')
        append(f'<div class="total">Total paid: {total:.2f} {currency}</div>')
        append("</div>")

    append("</body></html>")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(
        description="DOM-based invoice generator (no XSLT)."
    )
    parser.add_argument("--xml", default="operator.xml", type=Path, help="XML input")
    parser.add_argument(
        "--out", default=Path("outputs/invoice_dom.html"), type=Path, help="HTML output"
    )
    args = parser.parse_args()

    doc = minidom.parse(str(args.xml))
    clients = build_clients(doc)
    events = build_events(doc)
    bookings = gather_bookings(doc)
    html = render_html(bookings, clients, events)
    args.out.write_text(html, encoding="utf-8")
    print(f"Wrote DOM invoice to {args.out}")


if __name__ == "__main__":
    main()
