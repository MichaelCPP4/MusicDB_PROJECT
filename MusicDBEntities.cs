using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicDB_PROJECT
{
    public partial class MusicDBEntities : DbContext
    {
        private static MusicDBEntities context;

        public static MusicDBEntities GetContext()
        {
            if (context == null) context = new MusicDBEntities();
            return context;
        }

        public int GetTrackCountByGenre(int genreId)
        {
            int trackCount = 0;

            string connectionString = "data source=COMPUTER;initial catalog=MusicDB;user id=ИСП-31;password=1234567890;";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT dbo.GetTrackCountByGenre(@GenreId)", connection);
                command.Parameters.AddWithValue("@GenreId", genreId);
                trackCount = (int)command.ExecuteScalar();
            }

            return trackCount;
        }

        //DbFunction("MusicDBEntities"
        [DbFunction("YourModelContext", "GetMaxTrackNumberForAlbum")]
        public virtual int GetMaxTrackNumberForAlbum(int albumId)
        {
            var albumIdParameter = new SqlParameter("@albumId", albumId);

            // Выполнение SQL-запроса для вызова функции
            var result = Database.SqlQuery<int>("SELECT dbo.GetMaxTrackNumberForAlbum(@albumId)",
                                                albumIdParameter).FirstOrDefault();

            return result;
        }
        // Это хрень, самописная скалярная функция, это её пример
        public string GetArtistDescriptionByIndex(int index)
        {

            //Строка главное, если она не будет работать ошибки даже и не будет
            string connectionString = "data source=COMPUTER;initial catalog=MusicDB;user id=ИСП-31;password=1234567890;";
            string description = null;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT dbo.GetArtistDescriptionByIndex(@Index)", connection);
                command.Parameters.AddWithValue("@Index", index);
                description = (string)command.ExecuteScalar();
            }

            return description;
        }
    }
}
