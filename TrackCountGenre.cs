using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicDB_PROJECT
{
    public class TrackCountGenre
    {
        public string Name { get; set; }
        public int Count { get; set; }

        public TrackCountGenre(string name, int count)
        {
            Name = name;
            Count = count;
        }
    }
}
