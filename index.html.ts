export type Category = "Men" | "Women" | "Kids" | "Accessories" | "Footwear" | "Bags";
export type Product = { id: string; name: string; description: string; price: number; originalPrice?: number; category: Category; subcategory: string; rating: number; reviews: number; sizes: string[]; colors: string[]; stock: number; image: string; images: string[]; badge?: string; };
