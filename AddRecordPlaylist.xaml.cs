using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace MusicDB_PROJECT
{
    /// <summary>
    /// Логика взаимодействия для AddRecordPlaylist.xaml
    /// </summary>
    public partial class AddRecordPlaylist : Window
    {
        public AddRecordPlaylist()
        {
            InitializeComponent();
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        MusicDBEntities db = new MusicDBEntities();

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            //Playlist table = new Playlist();

            StringBuilder errors = new StringBuilder();

            if (textboxName.Text.Length == 0) errors.AppendLine("Введите название плейлиста.");

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString());
                return;
            }

            // Добвление трека
            //table.Id = db.Playlists.Max(item => item.Id) + 1;
            //table.Name = textboxName.Text;
            //table.Description = textBoxDescription.Text;

            try
            {
                db.AddPlaylist(db.Playlists.Max(item => item.Id) + 1, textboxName.Text, textBoxDescription.Text);
                //db.Playlists.Add(table);
                //db.SaveChanges();

                AddRecordTrackPlaylist addPlaylistTracks = new AddRecordTrackPlaylist();
                addPlaylistTracks.isAddNew = false;
                addPlaylistTracks.iDPlailist= db.Playlists.Max(item => item.Id);
                addPlaylistTracks.Owner = this;
                addPlaylistTracks.ShowDialog();

                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }
    }
}
