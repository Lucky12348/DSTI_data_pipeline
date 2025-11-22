"""
Generate operator.xml with simulated guides, clients, regions, tours, events, bikes, and bookings.
The output is deterministic (seeded) and valid against operator.xsd.
"""

import random
from datetime import date, timedelta
from pathlib import Path
import xml.etree.ElementTree as ET

OUTPUT_PATH = Path("operator.xml")


def text(elem, name, value):
    ET.SubElement(elem, name).text = value


def make_date(year, month, day):
    return date(year, month, day)


def span(start: date, days: int):
    return start, start + timedelta(days=days - 1)


def main():
    random.seed(42)

    root = ET.Element("Operator")

    # Guides
    guides_el = ET.SubElement(root, "Guides")
    guides = [
        ("g1", "Laura", "Martin", "laura.martin@example.com", "+33 6 11 22 33 44", "French,English", "Road tours", 5),
        ("g2", "Marco", "Rossi", "marco.rossi@example.com", "+39 333 555 666", "Italian,English", "Mountain biking", 8),
        ("g3", "Sofia", "Nunes", "sofia.nunes@example.com", "+351 912 345 678", "Portuguese,English,Spanish", "Electric tours", 6),
        ("g4", "Jonas", "Keller", "jonas.keller@example.com", "+49 151 2345678", "German,English", "Gravel", 7),
        ("g5", "Emma", "Dubois", "emma.dubois@example.com", "+33 6 66 77 88 99", "French,English,Spanish", "Family trips", 4),
    ]
    for gid, first, last, email, phone, langs, spec, exp in guides:
        g = ET.SubElement(guides_el, "Guide", {"id": gid})
        text(g, "FirstName", first)
        text(g, "LastName", last)
        text(g, "Email", email)
        text(g, "Phone", phone)
        text(g, "Languages", langs)
        text(g, "Specialty", spec)
        text(g, "ExperienceYears", str(exp))

    # Clients
    clients_el = ET.SubElement(root, "Clients")
    clients = [
        ("c1", "Anne", "Dupont", "anne.dupont@example.com", "+33 6 22 33 44 55", ("10 Rue de la Paix", "Paris", "75002", "France"), "1988-04-12"),
        ("c2", "John", "Smith", "john.smith@example.com", "+44 7700 900123", ("221B Baker Street", "London", "NW1 6XE", "United Kingdom"), "1990-09-30"),
        ("c3", "Luca", "Bianchi", "luca.bianchi@example.com", "+39 347 1234567", ("Via Roma 15", "Florencia", "50122", "Italy"), "1985-03-21"),
        ("c4", "Maria", "Gonzalez", "maria.gonzalez@example.com", "+34 612 345 678", ("Calle Mayor 8", "Madrid", "28013", "Spain"), "1992-07-19"),
        ("c5", "Sven", "Larsson", "sven.larsson@example.com", "+46 70 123 45 67", ("Storgatan 4", "Stockholm", "11120", "Sweden"), "1980-11-05"),
        ("c6", "Chloe", "Martin", "chloe.martin@example.com", "+33 6 33 44 55 66", ("5 Rue du Port", "Nantes", "44000", "France"), "1995-02-14"),
        ("c7", "Noah", "Garcia", "noah.garcia@example.com", "+1 415 555 0101", ("400 Market St", "San Francisco", "94105", "USA"), "1987-08-23"),
        ("c8", "Eva", "Keller", "eva.keller@example.com", "+49 171 2223344", ("Berliner Allee 22", "Berlin", "10117", "Germany"), "1993-12-01"),
        ("c9", "Tom", "Duran", "tom.duran@example.com", "+33 6 44 55 66 77", ("8 Rue des Lilas", "Lyon", "69000", "France"), "1982-05-30"),
        ("c10", "Isabel", "Silva", "isabel.silva@example.com", "+351 910 234 567", ("Rua das Flores 12", "Porto", "4000-001", "Portugal"), "1991-10-10"),
    ]
    for cid, first, last, email, phone, addr, birth in clients:
        c = ET.SubElement(clients_el, "Client", {"id": cid})
        text(c, "FirstName", first)
        text(c, "LastName", last)
        text(c, "Email", email)
        text(c, "Phone", phone)
        addr_el = ET.SubElement(c, "Address")
        street, city, zipc, country = addr
        text(addr_el, "Street", street)
        text(addr_el, "City", city)
        text(addr_el, "ZipCode", zipc)
        text(addr_el, "Country", country)
        text(c, "BirthDate", birth)

    # Regions and nested catalog data
    regions_el = ET.SubElement(root, "Regions")

    regions_data = [
        {
            "id": "r1",
            "name": "Loire Valley",
            "country": "France",
            "routes": [
                ("cr1", "Loire Riverside Path", 45.5, "Paved", "Easy", (47.34, 0.70)),
                ("cr2", "Amboise Castle Loop", 60.0, "Mixed", "Moderate", (47.41, 0.98)),
                ("cr3", "Vineyards Hills", 35.2, "Gravel", "Moderate", (47.29, 0.75)),
            ],
            "bikes": [
                ("b1", "Giant", "Defy Advanced", "Road", "Available", 35.0),
                ("b2", "Trek", "Domane SL", "Road", "Available", 40.0),
                ("b3", "Cannondale", "Trail 6", "Mountain", "InMaintenance", 30.0),
                ("b4", "Specialized", "Sirrus X", "Hybrid", "Available", 28.0),
                ("b5", "Moustache", "Samedi 27", "Electric", "Reserved", 55.0),
            ],
            "accommodations": [
                ("a1", "Hotel du Château", "Hotel", ("5 Avenue du Château", "Amboise", "37400", "France")),
                ("a2", "Loire Guesthouse", "Guesthouse", ("3 Rue des Vignes", "Blois", "41000", "France")),
            ],
            "rentals": [
                ("br1", "Loire Bikes Amboise", ("2 Quai de la Loire", "Amboise", "37400", "France"), "+33 2 47 00 11 22", "contact@loire-bikes-amboise.fr"),
            ],
            "tours": [
                ("t1", "Castles of the Loire", "Guided road cycling tour visiting castles along the Loire river.", 3, "Moderate", 450.0, ["cr1", "cr2"]),
                ("t2", "Loire E-Bike Escape", "Electric bike escape through vineyards and river banks.", 2, "Easy", 320.0, ["cr3"]),
            ],
        },
        {
            "id": "r2",
            "name": "Dolomites",
            "country": "Italy",
            "routes": [
                ("cr4", "Dolomite High Pass Loop", 75.0, "Mixed", "Hard", (46.54, 11.65)),
                ("cr5", "Valley Gravel Run", 50.0, "Gravel", "Moderate", (46.48, 11.55)),
            ],
            "bikes": [
                ("b6", "Specialized", "Turbo Levo", "Electric", "Available", 60.0),
                ("b7", "Scott", "Scale 960", "Mountain", "Available", 45.0),
                ("b8", "Canyon", "Grail 7", "Hybrid", "Reserved", 50.0),
                ("b9", "Orbea", "Gain", "Electric", "Available", 58.0),
                ("b10", "Bianchi", "Impulso", "Road", "Available", 42.0),
            ],
            "accommodations": [
                ("a3", "Dolomiti Mountain Hotel", "Hotel", ("Via delle Dolomiti 12", "Cortina d'Ampezzo", "32043", "Italy")),
                ("a4", "Passo Lodge", "Hostel", ("Via Roma 5", "Canazei", "38032", "Italy")),
            ],
            "rentals": [
                ("br2", "Dolomite Bike Center", ("Via Roma 5", "Cortina d'Ampezzo", "32043", "Italy"), "+39 0436 123456", "info@dolomite-bike.it"),
            ],
            "tours": [
                ("t3", "Dolomite Peaks Challenge", "Challenging mountain bike tour through high passes in the Dolomites.", 5, "Hard", 980.0, ["cr4"]),
                ("t4", "Gravel Valleys Discovery", "Gravel tour exploring valleys and forest roads in the Dolomites.", 4, "Moderate", 720.0, ["cr4", "cr5"]),
            ],
        },
    ]

    event_id_counter = 1

    for region in regions_data:
        r_el = ET.SubElement(regions_el, "Region", {"id": region["id"]})
        text(r_el, "Name", region["name"])
        text(r_el, "Country", region["country"])

        # Cycling routes
        routes_el = ET.SubElement(r_el, "CyclingRoutes")
        for rid, name, dist, surface, diff, coords in region["routes"]:
            cr = ET.SubElement(routes_el, "CyclingRoute", {"id": rid})
            text(cr, "Name", name)
            text(cr, "Distance", f"{dist:.1f}")
            text(cr, "Surface", surface)
            text(cr, "Difficulty", diff)
            coords_el = ET.SubElement(cr, "Coordinates")
            lat, lng = coords
            text(coords_el, "Lat", f"{lat:.4f}")
            text(coords_el, "Lng", f"{lng:.4f}")

        # Bikes
        bikes_el = ET.SubElement(r_el, "Bikes")
        for bid, brand, model, btype, status, price in region["bikes"]:
            b = ET.SubElement(bikes_el, "Bike", {"id": bid})
            text(b, "Brand", brand)
            text(b, "Model", model)
            text(b, "Type", btype)
            text(b, "Status", status)
            price_el = ET.SubElement(b, "DailyPrice", {"currency": "EUR"})
            price_el.text = f"{price:.2f}"

        # Accommodations
        acc_el = ET.SubElement(r_el, "Accommodations")
        for aid, name, atype, addr in region["accommodations"]:
            a = ET.SubElement(acc_el, "Accommodation", {"id": aid})
            text(a, "Name", name)
            text(a, "Type", atype)
            addr_el = ET.SubElement(a, "Address")
            street, city, zipc, country = addr
            text(addr_el, "Street", street)
            text(addr_el, "City", city)
            text(addr_el, "ZipCode", zipc)
            text(addr_el, "Country", country)

        # Bike rentals
        rentals_el = ET.SubElement(r_el, "BikeRentals")
        for rid, name, addr, phone, email in region["rentals"]:
            br = ET.SubElement(rentals_el, "BikeRental", {"id": rid})
            text(br, "Name", name)
            addr_el = ET.SubElement(br, "Address")
            street, city, zipc, country = addr
            text(addr_el, "Street", street)
            text(addr_el, "City", city)
            text(addr_el, "ZipCode", zipc)
            text(addr_el, "Country", country)
            text(br, "Phone", phone)
            text(br, "Email", email)

        # Tours and events
        tours_el = ET.SubElement(r_el, "Tours")
        for tid, title, desc, days, diff, base_price, route_refs in region["tours"]:
            t = ET.SubElement(tours_el, "Tour", {"id": tid})
            text(t, "Title", title)
            text(t, "Description", desc)
            text(t, "DurationDays", str(days))
            text(t, "Difficulty", diff)
            bp = ET.SubElement(t, "BasePrice", {"currency": "EUR"})
            bp.text = f"{base_price:.2f}"

            # Events (2 per tour)
            events_el = ET.SubElement(t, "TourEvents")
            for idx in range(2):
                start = make_date(2025, random.randint(5, 10), random.randint(1, 24))
                start, end = span(start, days)
                eid = f"e{event_id_counter}"
                event_id_counter += 1
                ev = ET.SubElement(events_el, "TourEvent", {"id": eid})
                text(ev, "StartDate", start.isoformat())
                text(ev, "EndDate", end.isoformat())
                text(ev, "MaxParticipants", str(random.choice([8, 10, 12, 15])))

                guides_el = ET.SubElement(ev, "Guides")
                # assign 1-2 guides
                for gref in random.sample(guides, k=random.choice([1, 2])):
                    gref_el = ET.SubElement(guides_el, "GuideRef", {"ref": gref[0]})

                cy_routes_el = ET.SubElement(ev, "CyclingRoutes")
                for rref in route_refs:
                    ET.SubElement(cy_routes_el, "CyclingRouteRef", {"ref": rref})

    # Bookings root (transactional)
    bookings_el = ET.SubElement(root, "Bookings")

    # Collect event ids for booking assignment
    all_events = [ev.get("id") for ev in root.findall(".//TourEvent")]
    all_bikes = [b.get("id") for b in root.findall(".//Bike")]
    all_clients = [c[0] for c in clients]
    payments_methods = ["CreditCard", "BankTransfer", "Cash"]

    booking_id = 1
    payment_id = 1
    for _ in range(12):
        bk = ET.SubElement(bookings_el, "Booking", {"id": f"bk{booking_id}"})
        booking_id += 1
        book_date = make_date(2025, random.randint(1, 4), random.randint(1, 28))
        text(bk, "BookingDate", book_date.isoformat())

        event_ref = random.choice(all_events)
        text(bk, "EventRef", event_ref)

        client_ref = random.choice(all_clients)
        text(bk, "ClientRef", client_ref)

        # Bikes selection
        if random.random() < 0.8:
            selected = random.sample(all_bikes, k=random.choice([1, 1, 2]))
            if selected:
                bb = ET.SubElement(bk, "BookedBikes")
                for bref in selected:
                    ET.SubElement(bb, "BookedBike", {"ref": bref})

        pays_el = ET.SubElement(bk, "Payments")
        payment_count = random.choice([1, 1, 2])
        for _ in range(payment_count):
            p = ET.SubElement(pays_el, "Payment", {"id": f"p{payment_id}"})
            payment_id += 1
            pay_date = book_date + timedelta(days=random.randint(0, 20))
            text(p, "Date", pay_date.isoformat())
            amt = round(random.choice([320.0, 450.0, 600.0, 720.0, 980.0]) * random.uniform(0.5, 1.1), 2)
            ET.SubElement(p, "Amount", {"currency": "EUR"}).text = f"{amt:.2f}"
            text(p, "Method", random.choice(payments_methods))

    # Serialize
    tree = ET.ElementTree(root)
    ET.indent(tree, space="    ")
    OUTPUT_PATH.write_bytes(ET.tostring(root, encoding="utf-8", xml_declaration=True))
    print(f"Wrote {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
