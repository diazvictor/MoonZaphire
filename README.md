<p align="center">
	<a href="https://github.com/diazvictor/MoonZaphire"><img src="https://github.com/diazvictor/MoonZaphire/raw/v3.0/logo.svg" alt="Logo"></a>
</p>

MoonZaphire is a GTK3 client for MQTT (and others) written in Lua with a lot of love.

> **IMPORTANT:** This project is under active development, therefore many 
> of the features are not yet available.

## Dependencies

- GTK+ 3.20+
- GObject-Introspection
- GLib 2.0+
- GdkPixbuf 2.0+
- Pango 1.0+
- [Lua5.1+](https://www.lua.org/download.html) (or [LuaJIT 2.0+](https://luajit.org/))
- [LGI](https://github.com/pavouk/lgi)
- Meson 0.53.0+

## Building and Installation

You can build and install MoonZaphire using Meson with Ninja:

Run `meson` to configure the build environment and then `ninja install` to install
```
meson build --prefix=/usr && cd build
[sudo] ninja install
```

To run the application
```
MoonZaphire
```

To run directly from source
```
cd src && lua MoonZaphire.lua
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Credits

Thanks to:
- [darltrash](https://github.com/darltrash) for the logo and some ideas for the application.
- [sodomon](https://github.com/sodomon2) for contributing the code and supporting the project.
- [vitronic](https://gitlab.com/vitronic) for guiding me in the construction of the application, in addition to developing a standard protocol for the application.

## License

MoonZaphire is available under the zlib license. Details can be found in the [LICENSE](LICENSE.md) file.
