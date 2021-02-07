<p align="center">
	<a href="https://github.com/diazvictor/MoonZaphire"><img src="https://github.com/diazvictor/MoonZaphire/raw/v3.0/logo.svg" alt="Logo"></a>
</p>

MoonZaphire is a GTK3 frontend for MQTT written in Lua with a lot of love.

> **IMPORTANT:** This project is under active development, therefore many 
> of the features are not yet available.

<p align="center">
	<img alt="UI Concept" src="https://github.com/diazvictor/MoonZaphire/raw/v3.0/ui-concept.png"/>
</p>

## Dependencies

- [Lua5.1+](https://www.lua.org/download.html) (or [LuaJIT 2.0+](https://luajit.org/))
- [LGI](https://github.com/pavouk/lgi)

## Running steps

Before running MoonZaphire, you'll need compile the `data/com.github.diazvictor.MoonZaphire.xml` file:

```
glib-compile-resources data/com.github.diazvictor.MoonZaphire.xml
```

Now all that remains is to run the application

```
lua MoonZaphire.lua
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

MoonZaphire is available under the zlib license. Details can be found in the [LICENSE](LICENSE) file.
