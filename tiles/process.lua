-- TrashTracker "bins" layer.
--
-- Matches OSM nodes tagged amenity=waste_basket, amenity=waste_disposal,
-- amenity=recycling, or bin=yes. The class attribute carries the matched
-- type through, so a consumer can tell the classes apart instead of
-- lumping them into one indistinguishable point type.
--
-- bin=yes is treated as class=waste_basket, but flagged precision=low.
-- It is commonly added to a bench or similar object rather than a
-- dedicated waste basket node, so it is a weaker signal than a proper
-- amenity tag. waste=* is optional for every class; it is recorded when
-- present but never required for a match.
--
-- All matched objects are almost always mapped as nodes in OSM, so
-- way_function has nothing to do.
--
-- The OSM node id is recorded as an explicit id attribute (see
-- set_common_attributes) and, separately, as the MVT feature id through
-- settings.include_ids in config.json. Either lets a consumer match a
-- feature back to its source node.
--
-- node_keys/way_keys: kept as a pure perf/defensive win, not a
-- correctness requirement — the pipeline now runs tilemaker via
-- ghcr.io/systemed/tilemaker (see claim-and-build/action.yml), not
-- apt's tilemaker 2.4.0. That old apt build was the actual cause of a
-- past incident: its GetSignificantNodeKeys read `node_keys` via kaguya
-- with no nil-guard, so an undefined `node_keys` made every region's
-- build abort with "kaguya::LuaTypeMismatch" converting Lua nil to a
-- C++ vector<string>, before a single node was processed. Current
-- tilemaker guards that read, so it's no longer required — but the
-- image tag isn't pinned to a release (it floats with upstream's
-- master), so keeping node_keys/way_keys defined costs nothing and
-- avoids depending on that guard staying in place. Must list every key
-- node_function branches on (amenity, bin) or a matching node gets
-- silently skipped instead of processed.
node_keys = { "amenity", "bin" }
way_keys = {}

local function set_common_attributes()
	Attribute("id", Id())

	local name = Find("name")
	if name ~= "" then
		Attribute("name", name)
	end

	local opening_hours = Find("opening_hours")
	if opening_hours ~= "" then
		Attribute("opening_hours", opening_hours)
	end
end

function node_function(node)
	local amenity = Find("amenity")
	local waste = Find("waste")

	if amenity == "waste_basket" then
		Layer("bins", false)
		Attribute("class", "waste_basket")
		if waste ~= "" then
			Attribute("waste", waste)
		end
		set_common_attributes()
	elseif amenity == "waste_disposal" then
		Layer("bins", false)
		Attribute("class", "waste_disposal")
		if waste ~= "" then
			Attribute("waste", waste)
		end
		set_common_attributes()
	elseif amenity == "recycling" then
		Layer("bins", false)
		Attribute("class", "recycling")

		local recycling_type = Find("recycling_type")
		if recycling_type ~= "" then
			Attribute("recycling_type", recycling_type)
		end
		set_common_attributes()
	elseif Find("bin") == "yes" then
		Layer("bins", false)
		Attribute("class", "waste_basket")
		Attribute("precision", "low")
		if waste ~= "" then
			Attribute("waste", waste)
		end
		set_common_attributes()
	end
end

function way_function(way)
end
