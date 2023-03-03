extensions [
  GIS
  profiler
  CSV
]

globals [
  basemap
  start-area
  end-area
  goal
  coord-start
  dist-traveled

  min-cost
  max-cost

  res-m

  origin

  hiker-n
  hiker-status

  file-1
  file-2
  stamp1
]

patches-own [
  cost
  impassable

  patch-counter
]

breed [ hikers hiker ]
breed [ targets target ]

hikers-own [
  patch-vision
  winner-patch
  step-lengths
  cur-step-length

  coord-list
]

to setup
  ca
  reset-ticks

  ;;set basemap gis:load-dataset "/Users/emilycoco/Desktop/ab-lcp-dispersals/test-data/DEM/DEM_test.asc"
  ;;set basemap gis:load-dataset "/Users/emilycoco/Desktop/ab-lcp-dispersals/cost-rasters/model-input-costs/test.asc"

  if (time-period = "MIS3" ) [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS3.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS3.asc"
    ]
  ]
  if (time-period = "MIS4-big-Caspian") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS4_bigCaspian.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS4_bigCaspian.asc"
    ]
  ]
  if (time-period = "MIS4-small-Caspian") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS4_smallCaspian.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS4_smallCaspian.asc"
    ]
  ]
  if (time-period = "MIS5a") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS5a.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS5a.asc"
    ]
  ]
  if (time-period = "MIS5b-high-water") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS5b_high.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS5b_high.asc"
    ]
  ]
  if (time-period = "MIS5b-low-water") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS5b_low.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/Desktop/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS5b_low.asc"
    ]
  ]
  if (time-period = "MIS5c") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS5c.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS5c.asc"
    ]
  ]
  if (time-period = "MIS5d-high-water") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS5d_high.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS5d_high.asc"
    ]
  ]
  if (time-period = "MIS5d-low-water") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS5d_low.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS5d_low.asc"
    ]
  ]
  if (time-period = "MIS5e") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS5e.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS5e.asc"
    ]
  ]
  if (time-period = "MIS6-big-Kara") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS6_bigKara.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS6_bigKara.asc"
    ]
  ]
  if (time-period = "MIS6-small-Kara") [
    if (desert-cost = "20%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-20/MIS6_smallKara.asc"
    ]
    if (desert-cost = "10%") [
      set basemap gis:load-dataset "/home/ec3307/ab-lcp-dispersals/cost-rasters/model-input-costs/LS-deserts-10/MIS6_smallKara.asc"
    ]
  ]

  ;; let trans-res patch-size-km / map-resolution-km ;;need to figure out these parameters for each basemap
  ;;set patch-size-km 1
  let trans-res patch-size-km / map-resolution-km
  resize-world 0 (( gis:width-of basemap - 1 ) / trans-res ) 0 (( gis:height-of basemap - 1 ) / trans-res )
  set-patch-size ( 0.05 * patch-size-km )                                   ;; This roughly keeps the size of the world window manageable
  gis:set-world-envelope gis:envelope-of basemap                         ;; This formats the window to the right dimensions based on the DEM
  gis:set-sampling-method basemap "BICUBIC_2"


  gis:apply-raster basemap cost

  set min-cost gis:minimum-of basemap
  set max-cost gis:maximum-of basemap

  set res-m 1000 * patch-size-km

  ;;need to think about this and what the impassable value should be
  ask patches [
    ifelse ( cost <= 0 ) or ( cost > 0 )
    [ set cost cost ]
    [ set cost 0 ]
  ]

  ask patches [
    update-colors
    ifelse cost = -999999
    [ set impassable true ]
    [ set impassable false ]
  ]

  let land patches with [ impassable = false ]

  ;;IMPORT AREA FOR START LOCATION
  ;;set start-area gis:load-dataset "/home/ec3307/ab-lcp-dispersals/start-end-locations/start-Caucacus.shp"
  set start-area gis:load-dataset "/home/ec3307/ab-lcp-dispersals/start-end-locations/start-Azov.shp"
  gis:set-drawing-color green
  gis:draw start-area 2
  let start-patches patches gis:intersecting start-area
  set start-patches start-patches with [ impassable = false ]

  set end-area gis:load-dataset "/home/ec3307/ab-lcp-dispersals/start-end-locations/end-Altai.shp"
  gis:set-drawing-color red
  gis:draw end-area 2
  let end-patches patches gis:intersecting end-area

  let list-start-grid sort start-patches
  let list-end-grid sort end-patches

  ask one-of list-start-grid [ stp-hikers ] ;; will need to update this to iterate through every start square
  ask one-of list-end-grid [ stp-goal ] ;; will need to update this to iterate through every end square


  if output? [
    set stamp1 random-float 1

     set file-1 (word "/home/ec3307/ab-lcp-dispersals/outputs/" "outputs_path_" origin "_" time-period "_" desert-cost "_" levy_mu "_" patch-size-km "_" stamp1 ".csv")
     set file-2 (word "/home/ec3307/ab-lcp-dispersals/outputs/" "LIST_outputs_path_" origin "_" time-period "_" desert-cost "_" levy_mu "_" patch-size-km "_" stamp1 ".csv")
     output-print file-2

;    if file-exists? file-1
;    [ file-delete file-1 ]
;
;    if file-exists? file-2
;    [ file-delete file-2 ]
  ]


end

to stp-hikers                                                        ;; Patch procedure that creates one hiker with specific attributes.

  sprout-hikers 1
  [ set color violet
    set size 5
    set shape "person"
    pen-down
    set hiker-n who                                                  ;; Records the hiker's ID number as a global variable
    set winner-patch patch-here                                      ;; Allows the hiker to start walking as soon as the run starts
    set origin patch-here
    set coord-start list ([xcor] of self) ([ycor] of self)
    set step-lengths []
    set coord-list []
  ]

end

to stp-goal                                                          ;; Patch procedure that creates one goal with specific attributes.

  sprout-targets 1
  [ set color blue
    set size 5
    set shape "house"
    set goal patch-here
  ]
end


to go

  ;; stops if hiker dies
  if not any? hikers [
    ask patches [ update-colors ]
    if output? = true [
      if lost-output? = true [
        ;export-path
        export-coord-list
      ]
    ]
    set hiker-status "dead"
    stop
  ]

  ;; stops if tick limit is reached
  if ticks = limit-ticks [
    ask patches [ update-colors ]
    if output? = true [
      if lost-output? = true [
        ;export-path
        export-coord-list
      ]
    ]
    set hiker-status "dead"
    stop
  ]

  ;; prevents agents from walking on patches over and over again
  ask patches with [ patch-counter != 0 ]
  [ set patch-counter patch-counter - 1 ]

  ;; agent-based least cost path
  ask hiker hiker-n [
    find-least-cost-path
  ]

  tick-advance 1

end

to find-least-cost-path

  let patch-under-me patch-here

  let c 0

  ifelse face-east? [
    face goal
    set patch-vision patches in-cone 1.5 200 ;; set hikers in direction of end goal
  ] [
    set patch-vision patches in-cone 1.5 360
  ]

  set patch-vision patch-vision with [ patch-counter = 0 ]
  set patch-vision patch-vision with [ impassable = false ]

  set c c + 1
  if c = 100 [
    die
    output-print "hiker died"
    stop
  ]

  ask patch-vision
  [ set pcolor pink
  ]

;  let flat patch-vision with [ cost < 2.7 ]
;  let gentle patch-vision with [ (cost >= 2.7) and (cost < 3.0)]
;
;  ifelse any? flat
;  [ set winner-patch one-of flat with-min [ cost ]]
;  [ ifelse any? gentle
;    [ set winner-patch one-of gentle with-min [ cost ]]
;    [ set winner-patch one-of patch-vision with-min [ cost ]]
;  ]

  set winner-patch one-of patch-vision with-min [cost]

  ifelse winner-patch = nobody
  [ stop ]
  [ face winner-patch
    get-step-length
    move
  ]

end

to get-step-length

  set cur-step-length (random-float 1.000) ^ (-1 / levy_mu)

  let new-territory count patch-vision
  if explore? [
    ;;if ([patch-counter] of winner-patch) = 0 [
      if new-territory >= 5 [
        set cur-step-length (cur-step-length * 2)
      ]
    ]

  set cur-step-length ( ceiling cur-step-length )

  set step-lengths lput cur-step-length step-lengths

end

to move

  let c 0

  foreach (range 1 cur-step-length) [

    let dist-winner-patch distance winner-patch
    move-to winner-patch
    update-plots
    ;output-print patch-here

    ask patch-here [
      set patch-counter 100
    ]

    set dist-traveled dist-traveled + ( dist-winner-patch * patch-size-km )

    set patch-vision patches in-cone 1.5 100 ;; keeps hikers headed in relatively the same direction as the original choice before the Levy walk
    set patch-vision patch-vision with [ impassable = false ]
    set patch-vision patch-vision with [ patch-counter = 0 ]

    ask patch-vision [
      set pcolor pink
    ]

;    let flat patch-vision with [ cost < 2.7 ]
;    let gentle patch-vision with [ (cost >= 2.7) and (cost < 3.0)]
;
;    ifelse any? flat
;    [ set winner-patch one-of flat with-min [ cost ]]
;    [ ifelse any? gentle
;      [ set winner-patch one-of gentle with-min [ cost ]]
;      [ set winner-patch one-of patch-vision with-min [ cost ]]
;    ]

    set winner-patch one-of patch-vision with-min [cost]
    ;output-print (word "agent wants to go to " winner-patch)

    ifelse winner-patch = nobody
    [
      set c c + 1
      if c = 100 [
        die
        output-print "hiker died"
      ]
      stop
    ]
    [ face winner-patch ]
  ]


end

to update-colors

  ifelse cost = -999999
    [ set impassable "true"
      set pcolor blue ]
    [ set pcolor scale-color green cost (min-cost * 100) (max-cost * 100) ]

end

to export-path

  file-open file-1
  export-plot "path" file-1
  output-print file-read-line
  file-close

end

to export-coord-list

  file-open file-2
  ask hiker hiker-n [
    csv:to-file file-2 coord-list
  ]
  file-close

end
@#$#@#$#@
GRAPHICS-WINDOW
301
10
870
603
-1
-1
1.314
1
10
1
1
1
0
0
0
1
0
426
0
444
0
0
1
ticks
30.0

BUTTON
18
54
84
87
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
92
55
155
88
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
18
101
249
270
path
tick
coord
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"path-x" 1.0 0 -16777216 true "" "if any? hikers [ plot [ xcor ] of hiker hiker-n ]"
"path-y" 1.0 0 -7500403 true "" "if any? hikers [ plot [ ycor ] of hiker hiker-n ]"

INPUTBOX
151
328
245
388
patch-size-km
10.0
1
0
Number

INPUTBOX
20
328
143
388
map-resolution-km
1.0
1
0
Number

SWITCH
19
278
123
311
output?
output?
0
1
-1000

SWITCH
131
278
265
311
lost-output?
lost-output?
0
1
-1000

INPUTBOX
170
33
242
93
limit-ticks
2500.0
1
0
Number

CHOOSER
21
491
113
536
time-period
time-period
"MIS3" "MIS4-big-Caspian" "MIS4-small-Caspian" "MIS5a" "MIS5b-high-water" "MIS5b-low-water" "MIS5c" "MIS5d-high-water" "MIS5d-low-water" "MIS5e" "MIS6-big-Kara" "MIS6-small-Kara"
0

CHOOSER
20
404
112
449
levy_mu
levy_mu
1 2 3
0

SWITCH
123
405
243
438
face-east?
face-east?
1
1
-1000

CHOOSER
124
491
216
536
desert-cost
desert-cost
"20%" "10%"
1

SWITCH
124
446
242
479
explore?
explore?
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)## WHAT IS IT?

This model simulates Lévy walks across a DEM-based cost raster surfaces, where each step take is based on the agent's evaluation of its local environment.

## HOW IT WORKS

The agent gets places at a random start location within a designated start area. The agent then looks at its local environment to find the least costly patch and faces that direction. Since the agent is moving via Lévy walks, a step length is determined for the agent's movement at each tick. The agent first moves to the previously determined least costly patch and then continues to find least costly patches to move to for each step from 1 to the step length. Once the end of the step length is reached, the process begins again. This process continues until the tick limit is reached.  

## HOW TO USE IT

The parameters in the interface tab allow you to determine four things for model run: 
1. which time period the cost surface will be based on (time-period), 
2. if the agent will initially face east (face-east?),
3. how large the step lengths of the agent can be (levy_mu),
4. whether outputs of the path should be recorded (outputs?, lost-outputs?)

The interface also allows the user to set the resolution of the model (patch-size-km) and limit how long the model runs (limit-ticks).  

This version of the model is setup for use on the NYU Greene HPC cluster. 


## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

This model makes use of the NetLogo GIS Extension.

## RELATED MODELS

Gravel-Miguel, C., Murray, J. K., Schoville, B. J., Wren, C. D. & Marean, C. W. Exploring variability in lithic armature discard in the archaeological record. Journal of Human Evolution 155, 102981 (2021).

Davies, B., Holdaway, S. & Fanning, P. C. Modeling Relationships Between Space, Movement, and Lithic Geometric Attributes. American Antiquity 83, 444–461 (2018).


## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="MIS3_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS3&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS6sk_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS6-small-Kara&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS6bk_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS6-big-Kara&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS4sc_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS4-small-Caspian&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS4bc_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS4-big-Caspian&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS5a_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS5a&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS5bh_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS5b-high-water&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS5bl_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS5b-low-water&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS5e_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS5e&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS5dh_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS5d-high-water&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS5dl_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS5d-low-water&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MIS5c_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS5c&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
      <value value="&quot;10%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_MIS3_levy-walks" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <enumeratedValueSet variable="output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lost-output?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="limit-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="face-east?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="explore?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="map-resolution-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-size-km">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-period">
      <value value="&quot;MIS3&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="desert-cost">
      <value value="&quot;20%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="levy_mu">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
