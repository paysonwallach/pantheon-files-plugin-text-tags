/*
 * Copyright (c) 2021 Payson Wallach
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

public class Files.Plugins.TagsMenuItem : Gtk.MenuItem {
    private File[] files;

    public TagsMenuItem (GLib.File[] files) {
        this.files = files;
        this.label = @"Edit tags";
    }

    public override void activate () {
        var dialog_controller = new TTagsDialogController (files);

        if (dialog_controller.dialog.run () == Gtk.ResponseType.ACCEPT)
            dialog_controller.save ();

        dialog_controller.dialog.destroy ();
    }

}

public class Files.Plugins.TTags : Files.Plugins.Base {
    private Gtk.Menu menu;

    private static GLib.File[] get_file_array (List<Files.File> files) {
        var file_array = new GenericArray<GLib.File> ();

        foreach (unowned Files.File file in files)
            if (file.location != null)
                if (file.location.get_uri_scheme () == "recent")
                    file_array.add (
                        GLib.File.new_for_uri (file.get_display_target_uri ()));
                else
                    file_array.add (file.location);

        return file_array.data;
    }

    public override void context_menu (Gtk.Widget widget, List<Files.File> gof_files) {
        menu = widget as Gtk.Menu;

        if (gof_files == null)
            return;

        foreach (var gof_file in gof_files)
            if (gof_file.info == null)
                return;

        add_menuitem (
            menu,
            new TagsMenuItem (
                get_file_array (gof_files)));
    }

    private void add_menuitem (Gtk.Menu menu, Gtk.MenuItem menu_item) {
        plugins.menuitem_references.add (menu_item);
        menu.append (menu_item);
        menu.reorder_child (menu_item, (int) menu.get_children ().length () - 3);
        menu_item.show ();
    }

}

public Files.Plugins.Base module_init () {
    return new Files.Plugins.TTags ();
}
