# trashtracker-tiles

A worldwide PMTiles layer of public waste baskets and disposal containers
(OSM `amenity=waste_basket` / `amenity=waste_disposal`, "Mülleimer"),
visible from zoom 10, built from Geofabrik OSM extracts via
[TileDistillery](https://github.com/foxandfeature/tiledistillery) — a
reusable GitHub Actions pipeline this repo only configures, it does not
implement any of the build mechanics itself.

## Layout

| Path | Purpose |
| --- | --- |
| `tiles/config.json` | tilemaker layer config: one `bins` layer, minzoom 10, maxzoom 14. |
| `tiles/process.lua` | tilemaker profile: emits every `amenity=waste_basket`/`amenity=waste_disposal` node into `bins`, tagged with `class` so the two stay distinguishable. |
| `.github/workflows/build.yml` | Calls TileDistillery's `_pipeline.yml` (weekly + manual), then publishes `bins.pmtiles` as a GitHub Release. |

## How it builds

See [TileDistillery's `docs/ARCHITECTURE.md`](https://github.com/foxandfeature/tiledistillery/blob/main/docs/ARCHITECTURE.md)
for the actual mechanics (region detection, the claim-based work queue,
merging). This repo only supplies the tilemaker config/profile and picks a
publish target.

## License / attribution

Map data built by this pipeline is OpenStreetMap data via Geofabrik,
© OpenStreetMap contributors, available under the
[Open Database License (ODbL)](https://www.openstreetmap.org/copyright).
