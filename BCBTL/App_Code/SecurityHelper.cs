using System;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace BCBTL
{
    /// <summary>
    /// Giai đoạn 8: Lớp hỗ trợ bảo mật trung tâm (Central Security Helper)
    /// Đảm nhiệm:
    /// 1. Băm mật khẩu một chiều với giải thuật SHA-256 (64 ký tự Hexadecimal).
    /// 2. Xác thực mật khẩu và hỗ trợ chuyển đổi mật khẩu cũ sang chuẩn băm an toàn.
    /// 3. Kiểm định định dạng mã băm SHA-256 hợp lệ.
    /// 4. Làm sạch dữ liệu đầu vào (XSS Sanitization & HTML Encoding).
    /// </summary>
    public static class SecurityHelper
    {
        private static readonly Regex Sha256Regex = new Regex("^[a-fA-F0-9]{64}$", RegexOptions.Compiled);

        /// <summary>
        /// Băm văn bản thuần (plain text) bằng thuật toán mã hóa SHA-256.
        /// Kết quả trả về là chuỗi 64 ký tự Hexadecimal viết thường.
        /// </summary>
        public static string HashPassword(string plainText)
        {
            if (string.IsNullOrEmpty(plainText)) return string.Empty;

            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(plainText));
                StringBuilder builder = new StringBuilder(64);
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }

        /// <summary>
        /// Kiểm tra tính khớp nối giữa mật khẩu người dùng nhập và mật khẩu lưu trong cơ sở dữ liệu.
        /// Hỗ trợ cả trường hợp mật khẩu đã băm SHA-256 lẫn cơ chế tương thích ngược (fallback).
        /// </summary>
        public static bool VerifyPassword(string plainText, string storedPassword)
        {
            if (string.IsNullOrEmpty(plainText) || string.IsNullOrEmpty(storedPassword))
            {
                return false;
            }

            string computedHash = HashPassword(plainText);

            // 1. So sánh chuẩn SHA-256 (không phân biệt hoa/thường)
            if (string.Equals(computedHash, storedPassword, StringComparison.OrdinalIgnoreCase))
            {
                return true;
            }

            // 2. Cơ chế tương thích: nếu trong DB còn lưu chuỗi thô chưa kịp băm
            if (string.Equals(plainText, storedPassword, StringComparison.Ordinal))
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// Kiểm tra xem một chuỗi có phải là chuỗi băm SHA-256 hợp lệ (độ dài đúng 64 ký tự hex) hay không.
        /// </summary>
        public static bool IsSha256(string input)
        {
            if (string.IsNullOrEmpty(input) || input.Length != 64) return false;
            return Sha256Regex.IsMatch(input);
        }

        /// <summary>
        /// Mã hóa HTML an toàn chống tấn công Cross-Site Scripting (XSS).
        /// Chuyển đổi các ký tự nguy hiểm: &lt;, &gt;, &quot;, &apos;, &amp; thành HTML Entities.
        /// </summary>
        public static string SanitizeXss(string rawInput)
        {
            if (string.IsNullOrEmpty(rawInput)) return string.Empty;
            return HttpUtility.HtmlEncode(rawInput.Trim());
        }
    }
}
