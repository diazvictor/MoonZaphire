sources = [
	'app.lua',
	'start.lua',
	'window.lua'
]

search_src_files = configuration_data()
search_src_files.set('datadir', datadir)
search_src_files.set('prefix', prefix)
configure_file (
	input: 'MoonZaphire.lua.in',
	output: 'MoonZaphire'.format(prefix, datadir),
	configuration: search_src_files,
	install: true,
	install_dir: get_option('bindir')
)

install_data(
	sources,
	install_dir: join_paths(get_option('datadir'), 'MoonZaphire/src'),
)

install_subdir('chat/', install_dir : join_paths(get_option('datadir'), 'MoonZaphire/src'))
install_subdir('chat_list/', install_dir : join_paths(get_option('datadir'), 'MoonZaphire/src'))
install_subdir('login/', install_dir : join_paths(get_option('datadir'), 'MoonZaphire/src'))
install_subdir('settings/', install_dir : join_paths(get_option('datadir'), 'MoonZaphire/src'))
