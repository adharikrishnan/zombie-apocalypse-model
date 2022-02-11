# Zombie-Apocalypse-Model
2D simulation of a Zombie Apocalypse created in Netlogo.

# Requirments 
This model require NetLogo to work. Fortunately, there is a web version of NetLogo available on the NetLogo sites that allows uploading, running and editing (with basic features, however) 
of custom created models.Simply download the .nlogo file, upload it to NetLogo web and the rest is self-explanatory (features and functionality will be covered below). For better performance and 
more features, I would suggest downloading and installing the NetLogo IDE and running the simulation through it. Be aware that there are two versions installed by default,
the 2D and 3D versions. You need the 2D version to run this model. 

Links: 
- NetLogo Web : http://netlogoweb.org/
- NetLogo IDE Download : http://ccl.northwestern.edu/netlogo/download.shtml

# What is it?
This model tests the chances of humans surviving when placed in the middle of a zombie apocalypse.

# How it works
Humans and Zombies move randomly around the world and each of them will be set to move at a random speed based on the slider. There are brown blocks in the world that represents buildings, the number of which can be set by the slider. The zombies become visible to the humans when they enter their range of vision, and humans will attempt to avoid the zombies. The zombies on the other hand, can only detect the humans with their smell radius, and if a human is detected, the zombie will attempt to move towards the human
When in contact with eachother, the humans will attempt to kill the zombies, while zombies attempt to convert the humans to zombies. The chances of either succeeding depends on the convert probability slider. The larger the probability, the higher the chances of the humans winning a confrontation and vice versa.

# How to use it
- The SETUP_WORLD button initializes the humans, zombies and buildings.
- The RUN_MODEL button starts and stops the model.
- The INITIAL_NUMBER_OF_ZOMBIES slider sets the initial number of zombies at the start of the simulation.
- The INITIAL_NUMBER_OF_HUMANS slider sets the initial number of humans at the start of the simulation.
- The NUMBER_OF_BUILDINGS slider sets the number of buildings.
- The CONVERT_PROBABILITY slider determines the chances of either the human or the zombie surviving a confrontation. Range is from 0 to 10, the higher the rating, the higher the chances of the humans winning and killing a zombie, and vice versa.
- The HUMAN_SPEED slider sets the speed of each human to a random value between 0 and the value set.
- The ZOMBIE_SPEED slider sets the speed of each zombie to a random value between 0 and the value set.
- The STOP_POINT slider sets the stop point for the simulation (the point being the tick count). Between 0 to 10000 ticks.

# Things to key an eye out for
Notice the number of humans surviving and zombies dying with higher CONVERT_PORBABAILITY values.
Notice the number of zombies increasing and the number of humans decreasing with lower CONVERT_PROBABILITY values.

# Things to try out 
Vary the number of humans and the number of zombies at the start of the simulation, along with varying CONVERT_PROBABILITY values.
Vary the number of buildings in the world.
Vary the speeds of the humans and the zombies with varying CONVERT_PROBABILITY values.

# Extending the model 
Give the humans and zombies health bars, varying amongst each of them.
Create weapons that can be picked up by humans and used to increase their chances of survival.
Create resources that can used by the humans, like food and water supplies , to increase their health and other stats.
Create other hazards that can cause harm to the humans.
