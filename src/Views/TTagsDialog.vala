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

public class TTagsDialog : Granite.Dialog {
    public signal void entry_activated (string text);

    static construct {
        var provider = new Gtk.CssProvider ();

        provider.load_from_resource ("/com/paysonwallach/tags/Application.css");

        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    public TTagsDialog (TagListView tag_list_view) {
        var header = new Granite.HeaderLabel ("Edit Tags");

        header.margin_start = 6;
        header.margin_end = 6;

        var entry = new Gtk.Entry ();

        entry.hexpand = true;
        entry.margin = 6;
        entry.margin_top = 6;
        entry.activate.connect (() => {
            entry_activated (entry.get_text ());
            entry.set_text ("");
        });

        var grid = new Gtk.Grid ();

        grid.margin_start = 6;
        grid.margin_end = 6;

        grid.attach (header, 0, 0);
        grid.attach (tag_list_view, 0, 1);
        grid.attach (entry, 0, 2);

        get_content_area ().add (grid);
        add_button ("Cancel", Gtk.ResponseType.CANCEL);

        var suggested_button = add_button ("Save", Gtk.ResponseType.ACCEPT);

        suggested_button
         .get_style_context ()
         .add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        show_all ();
    }

}
