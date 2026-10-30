using System;

namespace BCBTL
{
    [Serializable]
    public class CartItem
    {
        public int ProductID { get; set; }
        public string Title { get; set; }
        public string Image { get; set; }
        public decimal Price { get; set; }
        public decimal OriginalPrice { get; set; }
        public int Quantity { get; set; }
        public int StockQuantity { get; set; }
        public decimal TotalPrice
        {
            get { return Price * Quantity; }
        }
    }
}
