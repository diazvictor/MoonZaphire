sources = [
	'json.lua',
	'utils.lua'
]

install_data(
	sources,
	install_dir: join_paths(get_option('datadir'), 'MoonZaphire/lib'),
)

search_gresource = configuration_data()
search_gresource.set('datadir', datadir)
search_gresource.set('prefix', prefix)
configure_file (
	input: 'init.lua.in',
	output: 'init.lua'.format(prefix , datadir),
	configuration: search_gresource,
	install: true,
	install_dir: join_paths(get_option('datadir'), 'MoonZaphire/lib'),
)
