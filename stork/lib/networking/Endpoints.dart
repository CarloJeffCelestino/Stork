class Endpoints {
  // static const site_url = 'https://storkph-staging-admin.azurewebsites.net'; // 4.40
  static const site_url = 'https://admin.stork.ph'; // 4.40
  static const base_url = '$site_url/api/';

  static const appLandingSettings = 'home/applandingsetting';
  static const appStart = 'appstart';
  static const setLanguage = 'common/setlanguage';
  static const setCurrency = 'common/setCurrency';

  static const homePageBanner = 'slider/homepageslider';
  static const homeFeaturedProduct = 'home/featureproducts';
  static const homeBestsellerProducts = 'home/bestsellerproducts';
  static const homeNearbyProducts = 'home/homepagenearbyproducts';
  static const homeCategoryWithProducts = 'home/homepagecategorieswithproducts';
  static const homeManufacturers = 'home/manufacturers';

  static const userLogin = 'customer/login';
  static const userLogout = 'customer/logout';
  static const passwordRecovery = 'customer/passwordrecovery';
  static const passwordChange = 'customer/changepassword';
  static const userRegister = 'customer/register';
  static const customerInfo = 'customer/info';
  static const getStatesByCountry = 'country/getstatesbycountryid';

  static const getAvatar = 'customer/avatar';
  static const removeAvatar = 'customer/removeavatar';
  static const uploadAvatar = 'customer/uploadavatar';
  static const getOtp = 'customer/getotp';
  static const validateOtp = 'customer/validateotp';

  static const addressList = 'customer/addresses';
  static const addAddress = 'customer/addressadd';
  static const editAddress = 'customer/addressedit';
  static const deleteAddress = 'customer/addressdelete'; // no response body

  static const rewardPoints = 'order/customerrewardpoints';
  static const downloadableProducts = 'customer/downloadableproducts';
  static const userAgreement = 'customer/useragreement';
  static const contactUs = 'common/contactus';
  static const allVendors = 'catalog/vendor/all';
  static const contactVendor = 'common/contactvendor';

  static const getCart = 'shoppingcart/cart';
  static const updateCart = 'shoppingcart/updatecart';
  static const checkoutAttributeChange = 'shoppingcart/checkoutattributechange';
  static const applyCoupon = 'shoppingcart/applydiscountcoupon';
  static const removeCoupon = 'shoppingcart/removediscountcoupon';
  static const applyGiftCard = 'shoppingcart/applygiftcard';
  static const removeGiftCard = 'shoppingcart/removegiftcardcode';
  static const cartEstimateShipping = 'shoppingcart/cart/estimateshipping';

  static const orderHistory = 'order/history';
  static const orderDetails = 'order/orderdetails';
  static const orderShipmentDetails = 'order/orderdetails/shipment';
  static const reorder = 'order/reorder';
  static const orderRepostPayment = 'order/orderdetails/repostpayment';

  static const topicBySystemName = 'topic/details';
  static const topicById = 'topic/detailsbyid';

  static const getWishList = 'shoppingcart/wishlist';
  static const updateWishList = 'shoppingcart/updatewishlist';
  static const moveToCartFromWishList = 'shoppingcart/additemstocartfromwishlist';

  static const categoryTree = 'home/categorytree';
  static const productDetails = 'product/productdetails';
  static const addProductToCart = 'shoppingCart/AddProductToCart/details';
  static const addToCartFromProductBox = 'shoppingCart/addproducttocart/catalog';
  static const crossSellProduct = 'product/productsalsopurchased';
  static const relatedProducts = 'product/relatedproducts';
  static const productAttributeChange = 'shoppingcart/productattributechange';
  static const productEstimateShipping = 'product/estimateshipping';
  static const productByBarcode = 'product/getproductbybarcode';
  static const newProducts = 'product/newproducts';

  static const subscriptionStatus = 'backinstocksubscription/subscribe';
  static const customerSubscriptions = 'backinstocksubscription/customersubscriptions';

  static const productReviews = 'product/productreviews';
  static const addProductReview = 'product/productreviewsadd';
  static const addReviewHelpfulness = 'product/setproductreviewhelpfulness';

  static const getBilling = 'checkout/getbilling';
  static const saveBilling = 'checkout/savebilling';
  static const saveShippingAddress = 'checkout/saveshipping';
  static const saveShippingMethod = 'checkout/saveshippingmethod';
  static const savePaymentMethod = 'checkout/savepaymentmethod';
  static const confirmOrder = 'checkout/confirmorder';
  static const orderComplete = 'checkout/completed';

  static const paymentInfoUrl = "$site_url/nopstationcheckout/paymentinfo";
  static const redirectUrl = "$site_url/nopstationcheckout/redirect";
  static const generateCheckoutGuidUrl = "$site_url/nopstationcheckout/generateguid";

  static const productListCategoryTree = 'catalog/category';
  static const productListManufacturer = 'catalog/manufacturer';
  static const productListVendor = 'catalog/vendor';
  static const productListTag = 'catalog/tag/productsbytag';
  static const allManufacturers = 'catalog/manufacturer/all';

  static const search = 'catalog/search';
  static const advancedSearchOptions = 'catalog/search';
  static const searchAutocomplete = 'catalog/catalog/searchtermautocomplete';

  static const returnRequest = 'returnrequest/returnrequest';
  static const returnRequestHistory = 'returnrequest/history';

  // region file download
  static const returnRequestFileDownload = 'download/getfileupload';
  static const sampleDownload = 'download/sample';
  static const getDownload = 'download/getdownload';
  static const orderNote = 'download/ordernotefile';
  static const orderPdfInvoice = 'order/orderdetails/pdf';
  //

  // region Multipart file upload
  static const uploadFileReturnRequest = 'returnrequest/uploadfile';
  static const uploadFileProductAttribute = 'shoppingcart/uploadfileProductAttribute';
  static const uploadFileCheckoutAttribute = 'shoppingcart/uploadfileCheckoutAttribute';
  static const uploadCustomerAvatar = 'customer/uploadavatar';
  // endregion

  static const facebookUrl = "$site_url/facebookauthentication/login?returnurl=%2F";
  static const pageNotFoundUrl = "$site_url/page-not-found";
}
