using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Reflection;
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
    /// Логика взаимодействия для AddRecordTrackPlaylist.xaml
    /// </summary>
    public partial class AddRecordTrackPlaylist : Window
    {
        public AddRecordTrackPlaylist()
        {
            InitializeComponent();
        }


        MusicDBEntities db = new MusicDBEntities();
        int kol = 0;

        public bool isAddNew = true;
        public int iDPlailist;


        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            ComboBoxItem comboItem;

            foreach (var i in db.Tracks)
            {
                comboItem = new ComboBoxItem();
                comboItem.Content = i.Id.ToString() + " " + i.Name;
                comboBox.Items.Add(comboItem);
            }

            Playlist playlist = new Playlist();

            if (isAddNew)
            {
                playlist = db.Playlists.FirstOrDefault(p => p.Id == iDPlailist);
                var playlistTracks = db.Playlists
        .Where(p => p.Id == playlist.Id)
        .SelectMany(p => p.Tracks);

                listView.ItemsSource = playlistTracks.ToList();
            }
        }

        private void AddTrack_Click(object sender, RoutedEventArgs e)
        {
            if(comboBox.SelectedItem != null)
            {
                try
                {
                    listView.ItemsSource = null;

                    Playlist playlist = new Playlist();
                    Track track = new Track();

                    if (isAddNew)
                    {
                        playlist = db.Playlists.OrderByDescending(p => p.Id).FirstOrDefault();
                    }
                    else
                    {
                        playlist = db.Playlists.FirstOrDefault(p => p.Id == iDPlailist);
                    }

                    string[] findTracks = comboBox.Text.Split(' ');
                    int trackId = int.Parse(findTracks[0]);
                    track = db.Tracks.FirstOrDefault(c => c.Id == trackId);

                    playlist.Tracks.Add(track);

                    comboBox.Items.Remove(comboBox.SelectedItem);

                    db.SaveChanges();

                    var playlistTracks = db.Playlists
            .Where(p => p.Id == playlist.Id)
            .SelectMany(p => p.Tracks);

                    listView.ItemsSource = playlistTracks.ToList();
                    kol++;
                }
                catch (Exception)
                {
                    MessageBox.Show("Нельзя добавлять одинаковые треки, выберите другой!", "Ошибка!");
                }
            }
            else
            {
                MessageBox.Show("Выьерите трек и добавьте!","Ошибка!");
            }
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            if (kol>0)
            {
                Close();
            }
            else
            {
                MessageBox.Show("Добавте хотя бы один трек.","Ошибка!");
            }
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            if (kol<=0)
            {
                e.Cancel = true;
                MessageBox.Show("Добавьте хотя бы один трек.", "Ошибка!");
            }
            else
            {
                e.Cancel = false;
            }
        }
    }
}
