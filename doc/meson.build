scdoc = find_program('scdoc', required: get_option('man-pages'))
if not scdoc.found()
	subdir_done()
endif

man_pages = ['grim.1.scd']

foreach src : man_pages
	topic = src.split('.')[0]
	section = src.split('.')[1]
	output = '@0@.@1@'.format(topic, section)

	custom_target(
		output,
		input: src,
		output: output,
		command: scdoc,
		feed: true,
		capture: true,
		install: true,
		install_dir: '@0@/man@1@'.format(get_option('mandir'), section),
	)
endforeach
