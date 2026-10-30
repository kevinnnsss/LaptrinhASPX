using System;
using System.Configuration;

namespace BCBTL
{
    public static class DbContextHelper
    {
        public static WatchStoreDataContext GetContext()
        {
            string connStr = ConfigurationManager.ConnectionStrings["WatchStoreConnectionString"]?.ConnectionString
                          ?? ConfigurationManager.ConnectionStrings["layoutConnectionString"]?.ConnectionString
                          ?? "Data Source=localhost;Initial Catalog=layout;Integrated Security=True;Encrypt=False";
            return new WatchStoreDataContext(connStr);
        }
    }
}
