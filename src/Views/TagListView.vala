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

public class TagListView : Gtk.FlowBox {
    static construct {
        // TODO: find a better style to emulate for this container
        set_css_name ("entry");
    }

    public TagListView () {
        height_request = 100;
        margin = 6;
        margin_bottom = 0;
        row_spacing = 3;
        column_spacing = 3;
        selection_mode = Gtk.SelectionMode.NONE;
    }

}
