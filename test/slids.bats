#!/usr/bin/env bats
load common

setup_file() {
    mkdir -p "$RENDERS"
}

# ── Parameter contract ────────────────────────────────────────────────────────

@test "all documented parameters exist in SCAD file" {
    local params=(
        rack_width rack_height front_plate_thickness guide_rails_on

        component1 component1_width component1_depth component1_height
        component1_wire_holes component1_wire_diameter component1_air_holes
	component1_side_offset component1_up_offset 

	component2 component2_width component2_depth component2_height
        component2_wire_holes component2_wire_diameter component2_air_holes
	component2_side_offset component2_up_offset 

	component3 component3_width component3_depth component3_height
        component3_wire_holes component3_wire_diameter component3_air_holes
	component3_side_offset component3_up_offset 
        
        keystones1 keystones1_I_rotate keystones1_side_offset keystones1_up_offset 
	keystones1_num keystones1_spaceing keystones1_vertical 
	keystones2 keystones2_I_rotate keystones2_side_offset keystones2_up_offset 
	keystones2_num keystones2_spaceing keystones2_vertical
	
	hex_strut hex_spacing hex_bottom_frame

	half_height_holes case_thickness 
        front_plate_hole front_lip tolerance stopper_size
    )
    for p in "${params[@]}"; do
        param_defined "$p" || { echo "Missing parameter: $p"; return 1; }
    done
}

@test "unknown parameter name is caught before rendering" {
    run render_slide "should_not_exist" -D 'component_height=30'
    [ "$status" -ne 0 ]
}

# ── General previews ──────────────────────────────────────────────────────────

@test "default" {
    render_slide "default" -D  'guide_rails_on=false'
    assert_slide_exist "default"
}

@test "6-inch rack" {
    render_slide "6inch" -D 'rack_width=152.4' -D  'guide_rails_on=false'
    assert_slide_exist "6inch"
}

@test "2U" {
    render_slide "2u" -D 'rack_height=2' -D  'guide_rails_on=false'
    assert_slide_exist "2u"
}

@test "0.5U" {
    render_slide "half_u" -D 'rack_height=0.5' -D 'component1_height=15' -D  'guide_rails_on=false'
    assert_slide_exist "half_u"
}

@test "solid front plate" {
    render_slide "solid_front" -D 'front_plate_hole=false' -D  'guide_rails_on=false'
    assert_slide_exist "solid_front"
}

@test "air holes disabled" {
    render_slide "no_air" -D 'component1_air_holes=false' -D  'guide_rails_on=false'
    assert_slide_exist "no_air"
}

@test "front wire holes" {
    render_slide "wire_holes" -D 'component1_wire_holes=3' -D  'guide_rails_on=false'
    assert_slide_exist "wire_holes"
}

@test "thick case walls" {
    render_slide "thick_walls" -D 'case_thickness=10' -D  'guide_rails_on=false'
    assert_slide_exist "thick_walls"
}

@test "keystone jacks" {
    render_slide "keystones" -D 'keystones1=true' -D 'keystones2=true' -D  'guide_rails_on=false'
    assert_slide_exist "keystones"
}

@test "keystone jacks disabled" {
    render_slide "no_keystones" -D 'keystones1=false' -D 'keystones2=false' -D  'guide_rails_on=false'
    assert_slide_exist "no_keystones"
}


# ── Regression tests ──────────────────────────────────────────────────────────

@test "missing_air_holes" {
    render_slide "missing_air_holes" \
        -D 'rack_height=1' \
        -D 'component1_width=182' -D 'component1_depth=178' -D 'component1_height=36' \
        -D 'component1_air_holes=true' -D  'guide_rails_on=false'
    assert_slide_exist "missing_air_holes"
}
