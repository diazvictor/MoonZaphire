project('MoonZaphire',
	['c'],
	version: '3.0',
	license: 'zlib',
)

prefix = get_option('prefix')
datadir = get_option('datadir')
gnome = import ('gnome')
cc = meson.get_compiler ('c')

find_program('lua')
cc.find_library('gtk-3')

subdir ('data')
subdir ('lib')
subdir ('src')
