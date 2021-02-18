gnome.compile_resources(
	'com.github.diazvictor.MoonZaphire',
	'com.github.diazvictor.MoonZaphire.xml',
	gresource_bundle: true,
	install: true,
	install_dir: join_paths(get_option('datadir'), 'MoonZaphire/data'),
	source_dir: '..'
)

install_data(
	'com.github.diazvictor.MoonZaphire.desktop',
	install_dir: join_paths(get_option('datadir'), 'applications')
)

install_data(
	join_paths('icons', 'scalable', 'apps', 'com.github.diazvictor.MoonZaphire.svg'),
	install_dir: join_paths(get_option('datadir'), 'pixmaps')
)
