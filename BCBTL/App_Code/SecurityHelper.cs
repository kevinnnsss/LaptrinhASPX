using System;
using System.Security.Cryptography;
using System.Text;

namespace BCBTL
{
    public static class SecurityHelper
    {
        public static string HashPassword(string plainText)
        {
            if (string.IsNullOrEmpty(plainText)) return string.Empty;
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(plainText));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}
