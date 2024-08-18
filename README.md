# micro-diet-csound

This is a delivery of `diet_csound` and `microcsound` in one convenient
Docker container. Super-fun!

## To run:

* Have `docker` installed, obviously. I'll lave that one to you, per your OS
  packaging ecosystem.

* Build the image: `docker build -t micro-diet-csound .`

* Run the image: `docker run -it --device /dev/snd micro-diet-csound`

* Run a live example:
  ```
  cd /root/microcsound/microcsound/share/data
  microcsound -r JI_robot_fingers.mc
  ```

If you want to work with the container to develop your own `.mc` files, or
extend or develop your own `microcsound`-appropriate `csound` orchestra files,
it would make a great deal of sense to use a volume-mount parameter on the above
`docker run` command. See https://docs.docker.com/storage/volumes/

This image was tested in `Void Linux`; should also work on most Linux distros.
Eventually, I'll support a `pulseaudio` output, which should enable things for Mac.
I don't know how this works in Windows. Drop me a line if you do.

Cheers,

AKJ <akjmicro@gmail.com>

