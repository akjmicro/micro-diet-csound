# micro-diet-csound

This is a delivery of `diet_csound` and `microcsound` in one convenient
Docker container. Super-fun!

## To run:

* Have `docker` installed, obviously. I'll lave that one to you, per your OS
  packaging ecosystem.

* Build the image: `docker build --no-cache -t micro-diet-csound .`

* Run the image:
  ```
  docker run -it
    --device /dev/snd \
    --mount type=volume,source=microcsound_volume,target=/root \
    micro-diet-csound
  ```

  This command has a `--mount` volumme that ensures that any changes
  within the container under the `/root` directory will persist
  between container runs.

* Run a live example:
  ```
  cd /root/microcsound/microcsound/share/data
  microcsound -r JI_robot_fingers.mc
  ```

If you want to work with the container to develop your own `.mc` files, or
extend or develop your own `microcsound`-appropriate `csound` orchestra files,
it would make a great deal of sense to instead change the volume-mount parameter
on the above to be `--mount type=bind,...` when calling the `docker run` command.
See https://docs.docker.com/storage/volumes/

This image was tested in `Void Linux`; should also work on most Linux distros.
Eventually, I'll support a `pulseaudio` output, which should enable things for Mac.
I don't know how this works in Windows. Drop me a line if you do.

## Which audio device?

It has been observed that depending on the host computer's audio-card setup, the device
to use for `microcsound -r <some_piece.mc>` may in fact vary and not be the obvious "default"
audio card. In this case, we can do some probing with some handy installed tools that are
baked-in to the container image, and then use the installed `nano` editor and do the
following once the container is running:

```
root@42ee4f29a601:/# aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: PCH [HDA Intel PCH], device 0: ALC3246 Analog [ALC3246 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: PCH [HDA Intel PCH], device 3: HDMI 0 [HDMI 0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: PCH [HDA Intel PCH], device 7: HDMI 1 [HDMI 1]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: PCH [HDA Intel PCH], device 8: HDMI 2 [HDMI 2]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

# Ah, I see my device is card 0, device 0, which translates to hw:0,0
# On someone else's system, it might be Card 1, device 0 (e.g. hw:1,0)
# This is waht can vary. Let's test the theory:

root@42ee4f29a601:/# speaker-test -d hw:0,0

speaker-test 1.2.8

Playback device is default
Stream parameters are 48000Hz, S16_LE, 1 channels
Using 16 octaves of pink noise
Rate set to 48000Hz (requested 48000Hz)
Buffer size range from 2048 to 16384
Period size range from 1024 to 1024
Using max buffer size 16384
Periods = 4
was set period_size = 1024
was set buffer_size = 16384
...

# Now, armed with the correct info, we can configure some things.
# This will change to /root directory since you're running as root:

cd

# Edit .microcsound.toml

nano .micrcsound.toml
```

So, with `nano`, change the line with `RT_CSOUND_COMMAND_STUB` (that ends with `-odac`)
to end with something like `-odac:hw:1,0`. Basically, you'll have to experiment.
`-odac` by itself impies `-odac:hw:0,0`, so if you weren't getting sound, it's
likely something like `-odac:hw:1,0` that you need here.

That's it!

Cheers,

AKJ <akjmicro@gmail.com>
