using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Runtime.Remoting.Contexts;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace MusicDB_PROJECT
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            var tracks = db.TrackLists.ToList();
            var albums = db.AlbumLists.ToList();
            var artists = db.ArtistViews.ToList();
            var playlists = db.PlaylistViews.ToList();

            trackListView.ItemsSource = tracks;
            albumListView.ItemsSource = albums;
            artistsListView.ItemsSource = artists;
            playlistsListView.ItemsSource = playlists;
            
        }

        MusicDBEntities db = MusicDBEntities.GetContext();

        TrackList o = new TrackList();

        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            switch (tabControl.SelectedIndex)
            {
                // Добавить исполнителя
                case 0:
                    AddRecordArtist addArtist = new AddRecordArtist();
                    addArtist.Owner = this;
                    addArtist.ShowDialog();

                    artistsListView.ItemsSource = null;

                    var artists = db.ArtistViews.ToList();
                    artistsListView.ItemsSource = artists;
                    break;
                // Добавить альбом
                case 1:
                    AddRecordAlbum addAlbum = new AddRecordAlbum();
                    addAlbum.Owner = this;
                    addAlbum.ShowDialog();

                    albumListView.ItemsSource = null;

                    var album = db.AlbumLists.ToList();
                    albumListView.ItemsSource = album;

                    var tracksA = db.TrackLists.ToList();

                    trackListView.ItemsSource = tracksA;

                    break;
                // Добавить трек
                case 2:
                    AddRecordTrack addTrack = new AddRecordTrack();
                    addTrack.Owner = this;
                    addTrack.ShowDialog();

                    var tracks = db.TrackLists.ToList();

                    trackListView.ItemsSource = tracks;

                    break;
                case 3:
                    // Добавить плейлист
                    AddRecordPlaylist addPlaylist = new AddRecordPlaylist();
                    addPlaylist.Owner = this;
                    addPlaylist.ShowDialog();

                    playlistsListView.ItemsSource = null;
                    var playlist = db.PlaylistViews.ToList();
                    playlistsListView.ItemsSource = playlist;


                    tracksInplaylistsListView.ItemsSource = null;
                    break;
                default:
                    break;
            }
        }

        private void EditButton_Click(object sender, RoutedEventArgs e)
        {
            switch (tabControl.SelectedIndex)
            {
                // Редактирование исполнителя
                case 0:
                    if (artistsListView.SelectedItem != null)
                    {
                        ArtistView artistView = (ArtistView)artistsListView.SelectedItem;
                        Data.Name = artistView.Name;
                        Data.Country = artistView.Country;
                        Data.ID = db.Artists.FirstOrDefault(a => a.Name == Data.Name).Id;
                        EditRecordArtist editArtist = new EditRecordArtist();
                        editArtist.Owner = this;
                        editArtist.ShowDialog();

                        // Перезагрузка
                        artistsListView.SelectedItem = null;

                        var artists = db.ArtistViews.ToList();
                        artistsListView.ItemsSource = artists;
                    }
                    else
                    {
                        MessageBox.Show("Выберите сначала исполнителя!", "Ошибка!");
                    }
                    break;
                    // Редактирование альбома
                case 1:
                    if (albumListView.SelectedItem != null)
                    {
                        AlbumList albumView = (AlbumList)albumListView.SelectedItem;
                        Data.Name = albumView.AlbumName;
                        Data.releaseYear = albumView.ReleaseYear;
                        Data.ID = db.Albums.FirstOrDefault(a => a.Name == Data.Name).Id;
                        Data.Description = db.Albums.FirstOrDefault(a => a.Name == Data.Name).Description;

                        EditRecordAlbum editAlbum = new EditRecordAlbum();
                        editAlbum.Owner = this;
                        editAlbum.ShowDialog();

                        // Перезагрузка
                        albumListView.SelectedItem = null;

                        var albums = db.AlbumLists.ToList();
                        albumListView.ItemsSource = albums;
                    }
                    else
                    {
                        MessageBox.Show("Выберите сначала альбом!", "Ошибка!");
                    }
                    break;
                    // Редактировать трек
                case 2:
                    if (trackListView.SelectedItem != null)
                    {
                        TrackList tracklist = (TrackList)trackListView.SelectedItem;
                        Data.Name = tracklist.TrackName;
                        Data.albumId = (int)db.Tracks.FirstOrDefault(a => a.Name == Data.Name).AlbumId;
                        Data.length = tracklist.Duration;
                        Data.trackNumber = (int)db.Tracks.FirstOrDefault(a => a.Name == Data.Name).TrackNumber;
                        Data.Lyrics = db.Tracks.FirstOrDefault(a => a.Name == Data.Name).Lyrics;
                        Data.ID = db.Tracks.FirstOrDefault(a => a.Name == Data.Name).Id;

                        EditRecordTrack editTrack = new EditRecordTrack();
                        editTrack.Owner = this;
                        editTrack.ShowDialog();

                        // Перезагрузка
                        trackListView.SelectedItem = null;

                        var tracks = db.TrackLists.ToList();
                        trackListView.ItemsSource = tracks;
                    }
                    else
                    {
                        MessageBox.Show("Выберите сначала трек!", "Ошибка!");
                    }
                    break;
                // Редактировать плейлист
                case 3:
                    if (playlistsListView.SelectedItem != null)
                    {
                        PlaylistView playlistView = (PlaylistView)playlistsListView.SelectedItem;
                        Data.ID = playlistView.Id;
                        Data.Name = playlistView.PlaylistName;
                        Data.Description = db.Playlists.FirstOrDefault(a => a.Name == Data.Name).Description;

                        EditRecordPlaylist editPlaylist = new EditRecordPlaylist();
                        editPlaylist.Owner = this;
                        editPlaylist.ShowDialog();

                        // Перезагрузка
                        playlistsListView.SelectedItem = null;

                        var playlists = db.PlaylistViews.ToList();
                        playlistsListView.ItemsSource = playlists;
                    }
                    else
                    {
                        MessageBox.Show("Выберите сначала плейлист!", "Ошибка!");
                    }
                    break;
                default:
                    break;
            }
        }

        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            switch (tabControl.SelectedIndex)
            {
                // Удаление исполнителя
                case 0:
                    MessageBoxResult result;
                    result = MessageBox.Show("Удалить исполнителя?", "Удаление исполнителя.",
                        MessageBoxButton.YesNo, MessageBoxImage.Warning);
                    if (result == MessageBoxResult.Yes)
                    {
                        if(artistsListView.SelectedItem != null)
                        {
                            try
                            {
                                ArtistView artistView = (ArtistView)artistsListView.SelectedValue;
                                Artist artist = db.Artists.Find(artistView.Id);
                                db.Artists.Remove(artist);
                                db.SaveChanges();
                                db.ChangeTracker.Entries().ToList().ForEach(p => p.Reload());
                            }
                            catch (ArgumentOutOfRangeException)
                            {
                                MessageBox.Show("Упс... Что-то пошло не так.", "Ошибка!");
                            }
                        }
                        else
                        {
                            MessageBox.Show("Выберите артиста для удаления!", "Ошибка!");
                        }
                    }

                    //Перезапуск
                    artistsListView.ItemsSource = null;

                    var artists = db.ArtistViews.ToList();
                    artistsListView.ItemsSource = artists;
                    artistsListView.ItemsSource = db.ArtistViews.Local.ToBindingList();
                    break;
                // Удаление альбома
                case 1:
                    MessageBoxResult result2;
                    result2 = MessageBox.Show("Удалить альбом?", "Удаление альбома.",
                        MessageBoxButton.YesNo, MessageBoxImage.Warning);
                    if (result2 == MessageBoxResult.Yes)
                    {
                        if (albumListView.SelectedItem != null)
                        {
                            AlbumList albumView = (AlbumList)albumListView.SelectedValue;
                            var album = db.Albums.FirstOrDefault(a => a.Name == albumView.AlbumName);
                            db.Albums.Remove(album);
                            db.SaveChanges();
                            db.ChangeTracker.Entries().ToList().ForEach(p => p.Reload());
                            try
                            {
                            }
                            catch (ArgumentOutOfRangeException)
                            {
                                MessageBox.Show("Упс... Что-то пошло не так.", "Ошибка!");
                            }
                        }
                        else
                        {
                            MessageBox.Show("Выберите альбом для удаления!", "Ошибка!");
                        }
                    }
                    //Перезапуск
                    albumListView.ItemsSource = null;

                    var albums = db.AlbumLists.ToList();
                    albumListView.ItemsSource = albums;
                    albumListView.ItemsSource = db.AlbumLists.Local.ToBindingList();
                    break;
                // Удаление трека
                case 2:
                    MessageBoxResult result3;
                    result3 = MessageBox.Show("Удалить трек?", "Удаление трека.",
                        MessageBoxButton.YesNo, MessageBoxImage.Warning);
                    if (result3 == MessageBoxResult.Yes)
                    {
                        if (trackListView.SelectedItem != null)
                        {
                            TrackList trackView = (TrackList)trackListView.SelectedValue;
                            var track = db.Tracks.FirstOrDefault(a => a.Name == trackView.TrackName);
                            db.Tracks.Remove(track);
                            db.SaveChanges();
                            db.ChangeTracker.Entries().ToList().ForEach(p => p.Reload());
                            try
                            {
                            }
                            catch (ArgumentOutOfRangeException)
                            {
                                MessageBox.Show("Упс... Что-то пошло не так.", "Ошибка!");
                            }
                        }
                        else
                        {
                            MessageBox.Show("Выберите трек для удаления!", "Ошибка!");
                        }
                    }

                    //Перезапуск
                    trackListView.ItemsSource = null;
                    var tracks = db.TrackLists.ToList();
                    trackListView.ItemsSource = tracks;
                    trackListView.ItemsSource = db.TrackLists.Local.ToBindingList();
                    break;
                // Удаление трека
                case 3:
                    MessageBoxResult result4;
                    result4 = MessageBox.Show("Удалить плейлист?", "Удаление плейлиста.",
                        MessageBoxButton.YesNo, MessageBoxImage.Warning);
                    if (result4 == MessageBoxResult.Yes)
                    {
                        if (playlistsListView.SelectedItem != null)
                        {
                            PlaylistView playlistView = (PlaylistView)playlistsListView.SelectedValue;
                            var playlist = db.Playlists.FirstOrDefault(a => a.Id == playlistView.Id);
                            db.Playlists.Remove(playlist);
                            db.SaveChanges();
                            db.ChangeTracker.Entries().ToList().ForEach(p => p.Reload());
                            try
                            {
                            }
                            catch (ArgumentOutOfRangeException)
                            {
                                MessageBox.Show("Упс... Что-то пошло не так.", "Ошибка!");
                            }
                        }
                        else
                        {
                            MessageBox.Show("Выберите плейлист для удаления!", "Ошибка!");
                        }
                    }

                    //Перезапуск
                    playlistsListView.ItemsSource = null;
                    var playlists = db.PlaylistViews.ToList();
                    playlistsListView.ItemsSource = playlists;
                    playlistsListView.ItemsSource = db.PlaylistViews.Local.ToBindingList();
                    break;
                default:
                    break;
            }
        }

        private void ArtistsListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (artistsListView.SelectedIndex != -1)
            {
                int index = artistsListView.SelectedIndex;

                    textBoxArtists.Text = db.GetArtistDescriptionByIndex(index);
            }
        }

        private void playlistListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (playlistsListView.SelectedIndex != -1)
            {
                PlaylistView viewTable = (PlaylistView)playlistsListView.SelectedItem;

                int playlistIndex = (int)db.PlaylistViews.FirstOrDefault(a => a.PlaylistName == viewTable.PlaylistName)?.Id;
                
                var playlistTracks = db.Playlists
        .Where(p => p.Id == playlistIndex)
        .SelectMany(p => p.Tracks);


                tracksInplaylistsListView.ItemsSource = playlistTracks.ToList();
            }
        }

        private void AddButtonTrackInPlaylist_Click(object sender, RoutedEventArgs e)
        {
            AddRecordTrackPlaylist addPlaylistTracks = new AddRecordTrackPlaylist();
            int playlistId = playlistsListView.SelectedIndex + 1;
            addPlaylistTracks.iDPlailist = playlistId;
            addPlaylistTracks.isAddNew = false;
            addPlaylistTracks.Owner = this;
            addPlaylistTracks.ShowDialog();

            playlistsListView.UpdateLayout();

            if (playlistId != -1)
            {
                var playlistTracks = db.Playlists
        .Where(p => p.Id == playlistId)
        .SelectMany(p => p.Tracks);

                tracksInplaylistsListView.ItemsSource = playlistTracks.ToList();
            }
        }


        private void SeachButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                int trackId = db.SearchTracksByKeyword(textBoxseach.Text)
            .Select(t => t.Id)
            .Min();
                trackListView.SelectedIndex = trackId;
            }
            catch (Exception)
            {
                MessageBox.Show("Такого трека не найдено", "Поиск.");
            }
        }

        private void tabControl_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (tabControl.SelectedIndex == 2)
            {
                seachButton.IsEnabled = true;
                textBoxseach.IsEnabled = true;
                filterButton.IsEnabled = true;
            }
            else
            {
                seachButton.IsEnabled = false;
                textBoxseach.IsEnabled = false;
                filterButton.IsEnabled = false;
            }
        }

        private void FilterButton_Click(object sender, RoutedEventArgs e)
        {
                    FilterWin filterWin = new FilterWin();
                    filterWin.Owner = this;
                    filterWin.ShowDialog();

                    try
                    {
                        var table = db.Tracks.ToList();
                        IEnumerable<TrackList> filtered = table
                            .Where(p => p.AlbumId.HasValue && p.AlbumId.Value == Data.ID)
                            .Select(p => new TrackList
                            {
                                TrackName = p.Name,
                            });

                        var tempList = trackListView.Items.Cast<TrackList>().ToList();

                        tempList.RemoveAll(item => !filtered.Any(t => t.TrackName == item.TrackName));

                        trackListView.ItemsSource = null;
                        trackListView.ItemsSource = tempList;
                    }
                    catch
                    {

                    }
        }

        private void Window_Initialized(object sender, EventArgs e)
        {
            // Вход и определение прав пользователя
            Login login = new Login();
            login.ShowDialog();

            if (Data.Login == false) Close();
            if (Data.Right != "Администратор")
            {
                AddButton.IsEnabled = false;
                EditButton.IsEnabled = false;
                DeleteButton.IsEnabled = false;
                AddMenu.IsEnabled = false;
                EditMenu.IsEnabled = false;
                DeleteMenu.IsEnabled = false;
                AddButtonTrackInPlaylist.IsEnabled = false;
            }

            mainWindow.Title = mainWindow.Title + " : " + Data.FullName + " - " + Data.Right;
        }

        private void ResetButton_Click(object sender, RoutedEventArgs e)
        {
            var tracks = db.TrackLists.ToList();

            trackListView.ItemsSource = tracks;


            var artists = db.ArtistViews.ToList();

            artistsListView.ItemsSource = artists;


            var albums = db.AlbumLists.ToList();

            albumListView.ItemsSource = albums;


            var playlists = db.PlaylistViews.ToList();

            playlistsListView.ItemsSource = playlists;

            trackGenreListView.Items.Clear();
            for (int i = 1; i < db.Genres.Max(g => g.Id); i++)
            {
                TrackCountGenre o = new TrackCountGenre(db.Genres.FirstOrDefault(g => g.Id == i).Name, db.GetTrackCountByGenre(i));
                trackGenreListView.Items.Add(o);
            }
        }

        private void Exit_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void Info_Click(object sender, RoutedEventArgs e)
        {
            string info = "Привет! Добро пожаловать в \"Музыкальный каталог\" - программа для управления музыкальной коллекцией.\r\n\r\nВ этой программе вы сможете добавлять, просматривать и изменять авторов, альбомы, треки и плейлисты. Это идеальное решение для любителей музыки, которые хотят поддерживать порядок в своей библиотеке.\r\n\r\nДобавляйте ваших любимых авторов, исследуйте их альбомы и находите новые треки для плейлистов. Приложение предоставит детальную информацию о каждом треке, включая название, длительность и текст песни.\r\n\r\nИспользуйте удобные функции для изменения информации об авторах, альбомах и треках. Если нужно обновить данные или исправить ошибки, это можно сделать всего несколькими кликами.\r\n\r\nКонечно же, здесь есть функция удаления, которая поможет вам легко избавиться от ненужных записей в вашем каталоге. Вы полностью контролируете свою музыкальную коллекцию и можете создать идеальный список под свои предпочтения.\r\n\r\n\"Музыкальный каталог\" создан Ивановым Михаилом Андреевичем, студентом группы ИСП-31. Это курсовой проект.\r\n\r\nНаслаждайтесь простотой и функциональностью программы, и пусть ваша музыкальная коллекция станет ещё лучше и более организованной!";
            MessageBox.Show(info,"О программе.");
        }

        private void TrackGenreListView_Loaded(object sender, RoutedEventArgs e)
        {
            trackGenreListView.Items.Clear();
            for (int i = 1; i < db.Genres.Max(g => g.Id); i++)
            {
                TrackCountGenre o = new TrackCountGenre(db.Genres.FirstOrDefault(g => g.Id == i).Name, db.GetTrackCountByGenre(i));
                trackGenreListView.Items.Add(o);
            }
        }

        private void TrackListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (trackListView.SelectedIndex != -1)
            {
                int index = trackListView.SelectedIndex;
                string name;
                TrackList tracklist = (TrackList)trackListView.SelectedItem;
                name = tracklist.TrackName;
                textBoxLyrics.Text = db.Tracks.FirstOrDefault(a => a.Name == tracklist.TrackName).Lyrics;
            }
        }
    }
}