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

public class OrderedSet<G>: Gee.HashSet<G> {
    public G remove_at (int position) {
        var iter = iterator ();
        for (var i = 0 ; i < position + 1 ; i++)
            iter.next ();

        G elem = iter.@get ();
        iter.remove ();

        return elem;
    }

}
