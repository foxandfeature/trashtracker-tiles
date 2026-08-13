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

local function set_common_attributes(node)
	node:AttributeNumeric("id", node:Id())

	local name = node:Find("name")
	if name ~= "" then
		node:Attribute("name", name)
	end

	local opening_hours = node:Find("opening_hours")
	if opening_hours ~= "" then
		node:Attribute("opening_hours", opening_hours)
	end
end

function node_function(node)
	local amenity = node:Find("amenity")
	local waste = node:Find("waste")

	if amenity == "waste_basket" then
		node:Layer("bins", false)
		node:Attribute("class", "waste_basket")
		if waste ~= "" then
			node:Attribute("waste", waste)
		end
		set_common_attributes(node)
	elseif amenity == "waste_disposal" then
		node:Layer("bins", false)
		node:Attribute("class", "waste_disposal")
		if waste ~= "" then
			node:Attribute("waste", waste)
		end
		set_common_attributes(node)
	elseif amenity == "recycling" then
		node:Layer("bins", false)
		node:Attribute("class", "recycling")

		local recycling_type = node:Find("recycling_type")
		if recycling_type ~= "" then
			node:Attribute("recycling_type", recycling_type)
		end
		set_common_attributes(node)
	elseif node:Find("bin") == "yes" then
		node:Layer("bins", false)
		node:Attribute("class", "waste_basket")
		node:Attribute("precision", "low")
		if waste ~= "" then
			node:Attribute("waste", waste)
		end
		set_common_attributes(node)
	end
end

function way_function(way)
end
