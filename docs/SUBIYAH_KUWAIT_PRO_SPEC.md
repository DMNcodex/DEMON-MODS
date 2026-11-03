# SUBIYAH KUWAIT PRO — Project Specification

Status: Working requirements draft (2026-11-03). This document records requested features, not verified implementation or completed testing.

## Objective
A performance-conscious, recognizable Kuwait desert/highway map for BeamNG.drive, centered on Subiyah and Sheikh Jaber Al-Ahmad Causeway. Aim for accurate road positions and dimensions where reference data permits, with credible desert scenery. Previously discussed targets: ~95% positional/dimensional fidelity and ~85% overall visual realism; these are aspirations, not measured scores.

## Target environment
- BeamNG.drive: user-reported 0.40.4.0 build; confirm before testing.
- Development: Python 3.13, Blender 4.5 LTS portable (user-reported).
- Performance baseline: RTX 2060 SUPER at 1080p; benchmark actual frame rates before setting performance claims.

## Road network and bridges
- Main expressways and Jaber/Subiyah bridge should follow real-world alignment and plausible elevation.
- Ensure correct lane widths, continuous smooth driving surfaces, emergency shoulders and curbs outside driving lanes.
- Preserve bridge loops, guardrails and barriers. Provide safe turnarounds at map edges; do not let vehicles fall into the sea.
- Remove barriers only at designated roadside grocery pull-offs.
- No blocked U-turns or broken elevated-road connections.
- Main spawn: mid-Subiyah bridge; three additional spawn points near each end, subject to safe placement.

## AI and traffic
- Investigate AI traffic vehicles that appear in the UI but not in the world.
- Validate AI road graph, lanes, spawning, collision, and driving behavior; player car in AI mode should not crash due to bad routing.
- Desired police traffic vehicle: Kuwait-style Chevrolet Tahoe patrol (requires validated mod asset and configuration).
- Static parked cars near dunes and roadside gathering spots are props, NOT active traffic AI. Place only on emergency shoulders at approved marked locations.

## Desert and roadside details
- Sand dunes of small, medium and large sizes in the user-marked green regions.
- Sparse small native desert shrubs (e.g. arfj), not dense vegetation.
- Tire tracks on sand and selected asphalt areas; lightweight camps near approved dune zones.
- Kuwait-style electrical pylons at user-marked purple locations.
- Up to four roadside grocery vehicles/stalls per direction at user-marked pink areas; ~4 m between props as previously requested, subject to safe road clearance and visual review.
- Realistic Kuwait overhead highway signs at marked orange areas.

## Speed enforcement
- Kuwait-style speed cameras at user-marked light-blue positions.
- Requested gameplay behavior: flash when vehicle speed reaches or exceeds 130 km/h.
- Police pursuit is a desired future gameplay feature; do not claim implemented without verification.
- Note: posted real-world limits and in-game enforcement triggers are distinct; verify signs and road rules against reliable references.

## Lighting and atmosphere
- Consistent median-style street lighting on all main expressways and bridge segments, with adequate night visibility.
- Natural clouds and sun by day; moon and stars at night.
- Do not break existing sky/weather functionality while adjusting lighting.

## Reference annotations (not coordinates)
- Thin red: main multilane highways.
- Green: dunes; in later markup also indicated an elevated/overlapping road — distinguish by source image/context.
- Purple: electrical pylons; in later markup also marked broken bridge/map ends — distinguish by source image/context.
- Light blue: speed cameras.
- Orange: overhead signs.
- Pink: groceries and roadside parked-car/camp areas, depending on source image.
Reference screenshots were discussed previously but are NOT embedded in this repository. Obtain and label the actual images before implementing location-specific changes. Example geographic reference supplied by user: 29.6137474, 48.0586395 (not a substitute for a full surveyed map).

## Known issues reported, not independently verified
1. Curbs intersect roadway; road surface uneven/bouncy.
2. Roads too narrow and lack emergency shoulder.
3. Missing dunes, pylons and some bridge geometry/guardrails.
4. AI traffic not visible despite appearing in traffic list.
5. AI-controlled player car collides instead of following lanes.
6. Insufficient lighting on full expressway network.
7. Broken bridge endpoints and elevation mismatches.

## Safe implementation and acceptance
1. Inspect current map source, ZIP structure, road graph and assets; record current version and back up.
2. Convert each requirement into a tracked issue with image/coordinates where available.
3. Fix one subsystem per branch; run static validation, then in-game driving and AI tests.
4. Confirm bridges, shoulders, barriers, spawns, lighting and camera triggers with screenshots/video.
5. Measure performance at 1080p on representative hardware.
6. Record unresolved defects and rollback instructions. Do not publish a release without explicit approval.

## Scope and rights
Only use assets and data that the project is authorized to redistribute. Review licensing of imported terrain, map imagery, logos, vehicle models, and third-party mods before commercial release.
