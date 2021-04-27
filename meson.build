project(
  'com.paysonwallach.ttags-plugin',
  'vala', 'c',
  version: '0.1.0'
)

gnome = import('gnome')
vala = meson.get_compiler('vala')

add_project_arguments(
  '-DGETTEXT_PACKAGE=@0@'.format(meson.project_name()),
  language:'c'
)

as_resources = gnome.compile_resources(
  'as-resources',
  'data/' + meson.project_name() + '.gresource.xml',
  source_dir: 'data',
)

prefix = get_option('prefix')
lib_dir = get_option('libdir')
files_plugin_dir = join_paths(prefix, lib_dir, 'io.elementary.files', 'plugins')

gee_dep = dependency('gee-0.8')
glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
granite_dep = dependency('granite')
gtk_dep = dependency('gtk+-3.0')
json_dep = dependency('json-glib-1.0')
pango_dep = dependency('pango')
pantheon_files_core_dep = dependency('pantheon-files-core')
posix_dep = vala.find_library('posix')

subdir('data')
subdir('src')
