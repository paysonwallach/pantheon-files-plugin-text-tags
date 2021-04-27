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

public class TagView : Gtk.FlowBoxChild {
    private Gtk.Grid grid;

    public Tag tag { get; construct; }

    public signal void deleted ();

    static construct {
        set_css_name ("tag");
    }

    public TagView (Tag tag) {
        Object (tag: tag);

        var label = new Gtk.Label (tag.value);

        label.hexpand = true;
        label.tooltip_text = label.label;
        label.ellipsize = Pango.EllipsizeMode.END;

        var remove_button = new Gtk.Button.from_icon_name (
            "window-close-symbolic", Gtk.IconSize.MENU);

        remove_button.tooltip_text = "Remove Tag";
        remove_button.valign = Gtk.Align.CENTER;
        remove_button.relief = Gtk.ReliefStyle.NONE;
        remove_button.clicked.connect (() => deleted ());

        var spacer = new Gtk.Image ();

        spacer.icon_size = Gtk.IconSize.MENU;
        spacer.visible = true;
        spacer.set_size_request (Gtk.IconSize.MENU, Gtk.IconSize.MENU);

        halign = Gtk.Align.START;
        valign = Gtk.Align.START;
        width_request = 80;

        grid = new Gtk.Grid ();

        grid.add (remove_button);
        grid.add (label);
        grid.add (spacer);

        add (grid);
        show_all ();
    }
}
