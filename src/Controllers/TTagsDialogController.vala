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
 * along with _store program. If not, see <http://www.gnu.org/licenses/>.
 */

public class TTagsDialogController : Object {
    private const string FILE_ATTRIBUTE_TAGS = "xattr::tags";

    private Json.Generator generator;
    private Json.Parser parser;

    private File[] files;
    private Gee.ArrayList<Tag> tags;
    private Gee.ArrayList<Tag> deleted;

    private TTagsDialog _dialog;

    public TTagsDialog dialog {
        get {
            return _dialog;
        }
    }

    public TTagsDialogController (File[] files) {
        this.files = files;

        generator = new Json.Generator ();
        parser = new Json.Parser ();
        deleted = new Gee.ArrayList<Tag> ();

        tags = get_tags_for_files (files);
        tags.sort ((a, b) => {
            return strcmp (((Tag) a).value, ((Tag) b).value);
        });

        var tag_store = new ListStore (typeof (Tag));
        foreach (var tag in tags)
            tag_store.append (tag);

        tag_store.items_changed.connect ((position, removed, added) => {
            if (removed > 0)
                for (var i = 0 ; i < removed ; i++)
                    deleted.add (tags.remove_at ((int) position));
        });

        var tag_list_view_controller = new TagListViewController (tag_store);

        _dialog = new TTagsDialog (tag_list_view_controller.view);

        _dialog.entry_activated.connect ((text) => {
            var tag = new Tag (text);
            if (tags.contains (tag))
                return;

            var index = 0;
            if (tags.size > 0)
                for (index = 0 ; index < tags.size ; index++)
                    if (strcmp (tags[index].value, tag.value) == 1)
                        break;

            tags.insert (index, tag);
            tag_store.insert (index, tag);
        });
    }

    public void save () {
        foreach (var file in files) {
            try {
                var file_info = file.query_info (
                    FILE_ATTRIBUTE_TAGS, FileQueryInfoFlags.NONE);
                var file_tags = get_tags_for_file (file);

                foreach (var tag in tags)
                    if (!file_tags.contains (tag))
                        file_tags.add (tag);

                foreach (var tag in deleted)
                    if (file_tags.contains (tag))
                        file_tags.remove (tag);

                file_info.set_attribute_string (
                    FILE_ATTRIBUTE_TAGS,
                    string_from_array (file_tags.to_array ()));

                file.set_attributes_from_info (
                    file_info, FileQueryInfoFlags.NONE);
            } catch (Error err) {
                warning (err.message);
            }
        }
    }

    private Gee.ArrayList<Tag> get_tags_for_files (File[] files) {
        var tags_intersection = new Gee.ArrayList<Tag> ();

        foreach (var file in files) {
            var tags = get_tags_for_file (file);

            if (file == files[0])
                tags_intersection = tags;
            else
                tags_intersection.retain_all (tags);
        }

        return tags_intersection;
    }

    private Gee.ArrayList<Tag> get_tags_for_file (File file) {
        FileInfo? file_info = null;
        try {
            file_info = file.query_info (
                FILE_ATTRIBUTE_TAGS, FileQueryInfoFlags.NONE);
        } catch (Error e) {
            warning (e.message);
        }
        var tags_string = file_info.get_attribute_string (FILE_ATTRIBUTE_TAGS);

        Gee.ArrayList<Tag> tags;
        if (tags_string == null)
            tags = new Gee.ArrayList<Tag> ();
        else
            tags = set_from_array (array_from_string (tags_string));

        return tags;
    }

    private Gee.ArrayList<Tag> set_from_array (Tag[] arr) {
        var set = new Gee.ArrayList<Tag> ();

        foreach (var elem in arr)
            if (!set.contains (elem))
                set.add (elem);

        return set;
    }

    private string string_from_array (Tag[] data) {
        var root = new Json.Node (Json.NodeType.ARRAY);
        var array = new Json.Array ();

        root.set_array (array);
        generator.set_root (root);

        foreach (var item in data)
            array.add_string_element (item.value);

        return generator.to_data (null);
    }

    private Tag[] array_from_string (string data) {
        try {
            parser.load_from_data (data);
        } catch (Error e) {
            warning (e.message);
        }

        var json_array = parser.get_root ().get_array ();
        var num_nodes = json_array.get_elements ().length ();

        var ret_val = new Tag?[num_nodes];
        for (var i = 0 ; i < num_nodes ; i++)
            ret_val[i] = new Tag (json_array.get_string_element (i));

        return ret_val;
    }

}
