project(
	'grim',
	'c',
	version: '1.4.1',
	license: 'MIT',
	meson_version: '>=0.59.0',
	default_options: ['c_std=c11', 'warning_level=3', 'werror=true'],
)

cc = meson.get_compiler('c')

add_project_arguments(cc.get_supported_arguments([
	'-Wno-unused-parameter',
	'-Wundef',
]), language: 'c')

png = dependency('libpng')
jpeg = dependency('libjpeg', required: get_option('jpeg'))
math = cc.find_library('m')
pixman = dependency('pixman-1')
realtime = cc.find_library('rt')
wayland_client = dependency('wayland-client')
wayland_protos = dependency('wayland-protocols', version: '>=1.14')

is_le = host_machine.endian() == 'little'
add_project_arguments([
	'-DGRIM_LITTLE_ENDIAN=@0@'.format(is_le.to_int()),
	'-DHAVE_JPEG=@0@'.format(jpeg.found().to_int()),
], language: 'c')

subdir('contrib/completions')
subdir('protocol')

grim_files = [
	'box.c',
	'buffer.c',
	'main.c',
	'output-layout.c',
	'render.c',
	'write_ppm.c',
	'write_png.c',
]

grim_deps = [
	client_protos,
	math,
	pixman,
	png,
	realtime,
	wayland_client,
]

if jpeg.found()
	grim_files += ['write_jpg.c']
	grim_deps += [jpeg]
endif

executable(
	'grim',
	files(grim_files),
	dependencies: grim_deps,
	include_directories: 'include',
	install: true,
)

subdir('doc')

summary({
	'JPEG': jpeg.found(),
	'Manual pages': scdoc.found(),
}, bool_yn: true)
