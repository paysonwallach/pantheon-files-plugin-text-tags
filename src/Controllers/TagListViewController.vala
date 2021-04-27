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

public class TagListViewController : Object {
    private ListStore tags;

    private TagListView _view;

    public TagListView view {
        get {
            return _view;
        }
    }

    public TagListViewController (ListStore tags) {
        this.tags = tags;
        this._view = new TagListView ();

        _view.bind_model (tags, create_tag_view_for_tag);
    }

    private Gtk.Widget create_tag_view_for_tag (Object tag) {
        var tag_view = new TagView ((Tag) tag);

        tag_view.deleted.connect (() => {
            uint? position = null;
            if (tags.find ((Tag) tag, out position))
                tags.remove (position);
        });

        return tag_view;
    }

}
