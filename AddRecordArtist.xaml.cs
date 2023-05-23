using System;
using System.Collections.Generic;
using System.Data.Entity;
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
    /// Логика взаимодействия для AddRecordArtist.xaml
    /// </summary>
    public partial class AddRecordArtist : Window
    {
        public AddRecordArtist()
        {
            InitializeComponent();
        }

        MusicDBEntities db = MusicDBEntities.GetContext();

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            //Artist table = new Artist();

            StringBuilder errors = new StringBuilder();

            if (textboxName.Text.Length == 0) errors.AppendLine("Введите имя или название группы.");
            if (textBoxCountry.Text.Length == 0) errors.AppendLine("Введите страну исполнителя.");

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString());
                return;
            }

            //table.Id = db.Artists.Max(item => item.Id)+1;
            //table.Name = textboxName.Text;
            //table.Country = textBoxCountry.Text;
            //table.Description = textBoxDescription.Text;


            try
            {
                db.AddArtist(db.Artists.Max(item => item.Id) + 1, textboxName.Text, textBoxCountry.Text, textBoxDescription.Text);
                //db.Artists.Add(table);
                //db.SaveChanges();
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}
