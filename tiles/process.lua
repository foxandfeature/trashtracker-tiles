-- TrashTracker "bins" layer: every OSM node tagged either
-- amenity=waste_basket (small public waste baskets / Mülleimer) or
-- amenity=waste_disposal (larger waste containers / Müllcontainer),
-- worldwide. `class` carries the actual amenity value through, so a
-- consumer can still tell the two apart (e.g. different icons) instead of
-- lumping them into one indistinguishable point type. Both are almost
-- always mapped as nodes in OSM; way_function has nothing to do.

local BIN_AMENITIES = {
	waste_basket = true,
	waste_disposal = true,
}

function node_function(node)
	local amenity = Find("amenity")
	if BIN_AMENITIES[amenity] then
		Layer("bins")
		Attribute("class", amenity)

		local waste = Find("waste")
		if waste ~= "" then
			Attribute("waste", waste)
		end

		local operator = Find("operator")
		if operator ~= "" then
			Attribute("operator", operator)
		end

		local name = Find("name")
		if name ~= "" then
			Attribute("name", name)
		end
	end
end

function way_function()
	-- waste baskets/disposal points are almost always nodes; nothing to do here
end
