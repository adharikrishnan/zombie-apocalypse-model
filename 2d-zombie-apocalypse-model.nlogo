breed [humans person]
breed [zombies zombie]


humans-own[vis_rad vis_ang human_hit_radius zombie_sighted ]
zombies-own [smell_radius zombie_hit_radius]


to setup_world
  clear-all                                 ;clears world from pervious simulation
  reset-ticks                               ;resets the tick counter for the next simulation
  ask patches [set pcolor green]
  let spawn_radius 6



  create-turtles number_of_buildings [                    ; creates a 100 random blocks that act as solid structures
    create_blocks
  ]



  create-zombies initial_number_of_zombies [
    move-to one-of patches with [ pcolor = green and pcolor != blue] ; makes sure a zombie does not spawn on a block or a human
    set color red                                  ;zombie attributes
    set size 4
    set shape "person"
    set smell_radius 10
    set zombie_hit_radius 4

  ]

  create-humans initial_number_of_humans [

    if not any? zombies in-radius spawn_radius  ; so that the humans are spawned some distance from the zombies
    [
    move-to one-of patches with [ pcolor = green and pcolor != red ] ; makes sure a human does not spawn on a block or a zombie
    set color blue                                 ; human attributes
    set size 5
    set shape "person"
    set vis_ang 90
    set vis_rad random_radius
    set human_hit_radius 4
    ]
  ]
end

to run_model                           ;runs the model
  make_humans_move
  make_zombies_move
  if not any? humans [stop]
  if not any? zombies [stop]
  if ticks = stop_point [stop]
  tick
end


to create_blocks                      ; a function to create the solid blocks

  setxy random-xcor random-ycor
  set color brown
  set size 1
  set shape "square"
end


to detect_block
  if [pcolor] of patch-ahead 1 = brown [
    right 180
  ]
end


to-report random_radius
  let max_radius 20
  let min_radius 10
  let radius random (max_radius - min_radius) + 10  ; returns a random radius between 10 and 20
  report radius
end


to-report random_human_speed
  let speed random-float human_speed  ; returns a random speed for the humans, between 0 and the slider value
  report speed
end

to-report random_zombie_speed
  let speed random-float zombie_speed  ; returns a random speed for the zombies, between 0 and the slider value
  report speed
end


to make_humans_move  ; to make the humans move


  ask humans [
    detect_block
    set zombie_sighted zombie_seen
    if zombie_sighted = true[
      right 180                   ; to avoid the zombies
    ]
    right random 45 - random 45   ; random movement in any direction, limited to a maximum of 90 degrees
    let humans_speed random_human_speed
    fd humans_speed
    human_combat                  ; combat funtion if the human cannot avoid a zombie
  ]
end


to make_zombies_move              ; function to make the zombies move
  ask zombies [
    right random 45 - random 45
    let zombies_speed random_zombie_speed
    fd zombies_speed
    detect_block
    humans_detected              ; to detect humans in smell radius
    zombie_combat
  ]
end


to-report zombie_seen
  let seen false
  ask zombies in-cone vis_rad vis_ang [          ; vision cone for the humans to detect zombies
    set seen true
  ]
  report seen
end


to humans_detected

  let humans_smelled humans in-radius smell_radius
    if any? humans_smelled [                                         ; function to go after humans
    let closest-human min-one-of humans_smelled [distance myself]
    set heading towards closest-human
    ]
end

to zombie_combat
  ask humans in-radius zombie_hit_radius [           ; to attempt to convert the humans in range
    if random 10 < (10 - convert_probability) [
      ask one-of humans-here
      [
        set breed zombies
        set color red                           ;zombie attributes
        set size 4
        set shape "person"
        set smell_radius 10
        set zombie_hit_radius 1
    ]]

  ]
end

to human_combat                                    ; to attempt to fight and kill the zombies in range
  ask zombies in-radius human_hit_radius [
    if random 10 < convert_probability [
      die
  ]]
end



@#$#@#$#@
GRAPHICS-WINDOW
210
10
723
524
-1
-1
5.0
1
10
1
1
1
0
1
1
1
-50
50
-50
50
1
1
1
ticks
25.0

BUTTON
40
20
140
53
setup_world
setup_world
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
39
76
128
109
run_model
run_model
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
12
298
184
331
convert_probability
convert_probability
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
7
162
202
195
initial_number_of_zombies
initial_number_of_zombies
0
50
18.0
1
1
NIL
HORIZONTAL

SLIDER
6
210
200
243
initial_number_of_humans
initial_number_of_humans
0
50
45.0
1
1
NIL
HORIZONTAL

SLIDER
13
344
185
377
human_speed
human_speed
0
3
0.1
0.1
1
NIL
HORIZONTAL

SLIDER
13
390
185
423
zombie_speed
zombie_speed
0
3
0.8
0.1
1
NIL
HORIZONTAL

SLIDER
12
441
184
474
stop_point
stop_point
0
10000
6000.0
100
1
NIL
HORIZONTAL

SLIDER
11
254
183
287
number_of_buildings
number_of_buildings
0
200
200.0
10
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This model tests the chances of humans surviving when placed in the middle of a zombie apocalypse.

## HOW IT WORKS

Humans and Zombies move randomly around the world and each of them will be set to move at a random speed based on the slider. There are brown blocks in the world that represents buildings, the number of which can be set by the slider. The zombies become visible to the humans when they enter their range of vision, and humans will attempt to avoid the zombies. The zombies on the other hand, can only detect the humans with their smell radius, and if a human is detected, the zombie will attempt to move towards the human

When in contact with eachother, the humans will attempt to kill the zombies, while zombies attempt to convert the humans to zombies. The chances of either succeeding depends on the convert probability slider. The larger the probability, the higher the chances of the humans winning a confrontation and vice versa.  

## HOW TO USE IT

The SETUP_WORLD button initializes the humans, zombies and buildings.

The RUN_MODEL button starts and stops the model.

The INITIAL_NUMBER_OF_ZOMBIES slider sets the initial number of zombies at the start of the simulation.

The INITIAL_NUMBER_OF_HUMANS slider sets the initial number of humans at the start of the simulation.

The NUMBER_OF_BUILDINGS slider sets the number of buildings.

The CONVERT_PROBABILITY slider determines the chances of either the human or the zombie surviving a confrontation. Range is from 0 to 10, the higher the rating, the higher the chances of the humans winning and killing a zombie, and vice versa.

The HUMAN_SPEED slider sets the speed of each human to a random value between 0 and the value set. 

The ZOMBIE_SPEED slider sets the speed of each zombie to a random value between 0 and the value set.

The STOP_POINT slider sets the stop point for the simulation (the point being the tick count). Between 0 to 10000 ticks.


## THINGS TO NOTICE

Notice the number of humans surviving and zombies dying with higher CONVERT_PORBABAILITY values.

Notice the number of zombies increasing and the number of humans decreasing with lower CONVERT_PROBABILITY values. 

## THINGS TO TRY

Vary the number of humans and the number of zombies at the start of the simulation, along with varying CONVERT_PROBABILITY values.

Vary the number of buildings in the world.

Vary the speeds of the humans and the zombies with varying CONVERT_PROBABILITY values.


## EXTENDING THE MODEL

Give the humans and zombies health bars, varying amongst each of them.

Create weapons that can be picked up by humans and used to increase their chances of survivle.

Create resources that can used by the humans, like food and water supplies , to increase their health and other stats.

Create other hazards that can cause harm to the humans.


## CREDITS AND REFERENCES

Model created by Advaith Harikrishnan (2021)

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
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
