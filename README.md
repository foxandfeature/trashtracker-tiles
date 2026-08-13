# trashtracker-tiles

A worldwide PMTiles layer of public waste baskets, waste disposal
containers, and recycling points (OSM `amenity=waste_basket`,
`amenity=waste_disposal`, `amenity=recycling`, and `bin=yes` as a lower
precision proxy for a waste basket), visible from zoom 10, built from
Geofabrik OSM extracts via
[TileDistillery](https://github.com/foxandfeature/tiledistillery).
TileDistillery is a reusable GitHub Actions pipeline that this repo only
configures; it does not implement any of the build mechanics itself.

## Layout

| Path | Purpose |
| --- | --- |
| `tiles/config.json` | tilemaker layer config: one `bins` layer, minzoom 10, maxzoom 14, with `include_ids` enabled so every feature also carries its OSM node id as the tile's own feature id. |
| `tiles/process.lua` | tilemaker profile: emits nodes tagged `amenity=waste_basket`, `amenity=waste_disposal`, `amenity=recycling`, or `bin=yes` into `bins`, tagged with `class` (`waste_basket`, `waste_disposal`, or `recycling`) so the types stay distinguishable. `bin=yes` nodes are tagged `class=waste_basket` with `precision=low`, since that tag is a weaker signal than a proper amenity tag. Every feature also carries an `id` attribute plus `name` and `opening_hours` when present; `waste` is recorded for the waste classes and `recycling_type` for recycling, both optional. |
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
