# VeriRequest — Operator Playbook
*Updated 17 July 2026. The plan to land school #1 and build from there.*

---

## 1. Honest diagnosis: why 345 emails produced zero replies

This wasn't bad luck. Five structural problems, in order of damage:

1. **Wrong inbox.** `office@` / `admin@` are gatekeepers whose job includes deleting vendor email. The buyer is the school business manager (SBM), the DPO, or the head — the email never reached them.
2. **Zero personalisation.** "Hi," with no school name reads as bulk mail and dies in two seconds. (Your data had head names and school names the whole time — they just weren't used.)
3. **One-shot sends.** No follow-ups. In B2B cold email most replies come on touches 2–4.
4. **No trust surface.** A school googling you found a thin site, no LinkedIn, no proof. Nobody buys data-handling services from a ghost.
5. **Timing mismatch.** Schools only *feel* this problem in the week a SAR lands. Cold email mostly arrives in the other 51 weeks. Outreach alone can't win — you must also be **findable at the moment of need** (search) and **already in their drawer** (the checklist).

Deliverability (SPF/DKIM/DMARC) checked out fine — the plumbing was never the problem. The message was.

## 2. What changed today (systems now in place)

- **Enriched list**: `data/outreach_list_enriched.csv` — 21,138 schools with school name, head name/title, phase, town (100% match).
- **Outbound engine v2**: personalised, gatekeeper-aware copy asking the office to *forward* to the SBM/DPO; 3-touch sequence (day 0, +4, +8 business days); 10 new schools/day; credentials in `.env`; January contacts get re-approached fresh with the new copy; `--dry-run` mode to preview any day's plan.
- **Lead magnet**: the safeguarding SAR checklist you'd been promising now actually exists (`assets/downloads/`) and is linked from every email — no "reply CHECKLIST" friction.
- **Website**: schools-first, free-triage offer, checklist section, new logo/favicon, SEO for "SAR support schools".
- **Reply handling**: add any school that replies to `data/replied_list.csv` (they exit the sequence immediately). Unsubscribes go in `data/unsubscribe_list.csv` as before.

## 3. The calendar problem you must respect: it's mid-July

Schools break up in ~1 week and offices run skeleton staff until September.

- **Now → 24 July**: let the engine run. Follow-ups to June contacts land while staff are still in.
- **25 July → 31 Aug**: **pause the daily send** (just don't run it). Cold email into an empty office = burned contacts. Use August for the trust-building list below.
- **1st week of September**: do NOT send — offices are drowning in start-of-term.
- **Mid-September onwards**: full engine on. Autumn term is also when complaint-season SARs start arriving.

## 4. August build list (trust, in priority order)

You said no school wants to be first, and you're right — so manufacture the trust signals that make you look established:

1. **ICO registration** (~£40/yr). You handle personal data; you almost certainly need it legally anyway, and "ICO registered (ZAxxxxxx)" in your footer and emails is a real trust signal. Do this first.
2. **Professional indemnity + cyber insurance.** Schools' procurement will ask. "Insured" goes on the site.
3. **Enhanced DBS check.** You'll touch safeguarding records; schools think in DBS terms. Cheap, powerful line in an email signature.
4. **LinkedIn profile + company page.** Post the checklist. Then one short practical post a week (term-time): "the third-party rule most school SARs get wrong", etc. SBMs and DPOs are on LinkedIn.
5. **Template pack**: data processing agreement + NDA ready to send within the hour of any enquiry. Speed here is itself a trust signal.
6. **A named human on the website.** "VeriRequest is run by Jake Woodward" with a photo beats an anonymous brand for a service this sensitive. Anonymous = risky; a person = accountable.

## 5. The channel most likely to land school #1 (work it in September)

**Partner with the people schools already trust: outsourced DPO providers.**
Hundreds of companies and local authorities sell "DPO as a service" to schools. They advise on SARs — but most *hate* doing the redaction grunt work. You are their subcontractor, white-label or referral:

- One DPO provider = access to 50–500 schools that already trust them.
- Their recommendation destroys the "who are you?" problem completely.
- Pitch: "Your schools' SAR redaction, done at fixed cost, under your review. You stay the advisor; I do the labour."
- Find them: search "school DPO service", LA traded services catalogues, MAT service directories. Ten well-researched emails to DPO providers may be worth more than ten thousand to school offices.

Secondary channels: SBM Facebook/forum communities (ISBL, SBM Twitter/X, EduPeople groups — be useful, not salesy), and answering the moment-of-need search ("school SAR redaction help") which the site is now optimised for.

## 6. Offer (locked in on the site)

- **Free triage and scoping**, fixed quote within one working day, pay only on go-ahead. This is the trust bridge: a school with a live SAR risks nothing by sending you the scope.
- Fixed price per job, never hourly. Indicative internal anchors (don't publish yet): small/simple ~£250–£450; typical parental SAR with safeguarding material ~£500–£1,200; multi-year/multi-child or grievance-linked £1,200+. Adjust after your first three quotes teach you the real market.
- For the first paying school: over-deliver hard, then ask for a short testimonial and permission to say "trusted by a [phase] school in [county]". That line unlocks schools 2–10.

## 7. Weekly operating cadence (term-time, ~5 hrs/week)

| Day | Action |
|---|---|
| Mon–Fri | Engine runs 08:00–09:00 automatically; check inbox twice daily, reply to anything within 2 hours |
| Mon | `--dry-run` sanity check; move replies → `replied_list.csv` |
| Tue | 1 LinkedIn post (practical, term-relevant) |
| Wed | 5 personal, hand-written emails to DPO providers / MAT data leads |
| Fri | Metrics review (below) + prune bounces from the list |

**Metrics that matter:** replies per 100 sends (target ≥2 once running; below 1 after 300 sends = change the copy again), checklist downloads (Cloudflare analytics), quotes issued, quote→win rate. Ignore vanity metrics.

## 8. When a reply comes in (the whole game)

1. Respond within 2 hours, even just "I'm on it — scope questions coming this afternoon."
2. Offer a 15-minute call same/next day; send the DPA + NDA proactively.
3. Fixed quote in writing within one working day, with delivery date.
4. Deliver early. Then ask for the testimonial.

One school, handled brilliantly, is the entire flywheel: testimonial → case study → "trusted by schools" → DPO-provider partnerships get easier → school #10.

---
*Files: engine `scraper/send_daily_emails.py` · list `data/outreach_list_enriched.csv` · checklist PDF `assets/downloads/` · replies `data/replied_list.csv`*
