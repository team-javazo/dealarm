package kr.co.dong.deal;


public class DealMatchDTO {
	private int id; 
	private String user_id;  
	private int deal_id; 
	private String matched_at;
	
	//deal_summary join용
	private String title;
	private String url;
	private int price;
	private String site;
	private String posted_at;
	private String created_at;
	private int likes;
	private String img;
	
	
	public DealMatchDTO() {}
	
	


	public DealMatchDTO(String title, String url, int price, String site, String posted_at, String created_at, int likes,
			String img) {
		super();
		this.title = title;
		this.url = url;
		this.price = price;
		this.site = site;
		this.posted_at = posted_at;
		this.created_at = created_at;
		this.likes = likes;
		this.img = img;
	}




	public DealMatchDTO(int id, String user_id, int deal_id, String matched_at, String title, String url, int price,
			String site, String posted_at, String created_at, int likes, String img) {
		super();
		this.id = id;
		this.user_id = user_id;
		this.deal_id = deal_id;
		this.matched_at = matched_at;
		this.title = title;
		this.url = url;
		this.price = price;
		this.site = site;
		this.posted_at = posted_at;
		this.created_at = created_at;
		this.likes = likes;
		this.img = img;
	}


	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public String getUser_id() {
		return user_id;
	}


	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}


	public int getDeal_id() {
		return deal_id;
	}


	public void setDeal_id(int deal_id) {
		this.deal_id = deal_id;
	}


	public String getMatched_at() {
		return matched_at;
	}


	public void setMatched_at(String matched_at) {
		this.matched_at = matched_at;
	}


	public String getTitle() {
		return title;
	}


	public void setTitle(String title) {
		this.title = title;
	}


	public String getUrl() {
		return url;
	}


	public void setUrl(String url) {
		this.url = url;
	}


	public int getPrice() {
		return price;
	}


	public void setPrice(int price) {
		this.price = price;
	}


	public String getSite() {
		return site;
	}


	public void setSite(String site) {
		this.site = site;
	}


	public String getPosted_at() {
		return posted_at;
	}


	public void setPosted_at(String posted_at) {
		this.posted_at = posted_at;
	}


	public String getCreated_at() {
		return created_at;
	}


	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}


	public int getLikes() {
		return likes;
	}


	public void setLikes(int likes) {
		this.likes = likes;
	}


	public String getImg() {
		return img;
	}


	public void setImg(String img) {
		this.img = img;
	}


	@Override
	public String toString() {
		return "DealMatchDTO [id=" + id + ", user_id=" + user_id + ", deal_id=" + deal_id + ", matched_at=" + matched_at
				+ ", title=" + title + ", url=" + url + ", price=" + price + ", site=" + site + ", posted_at="
				+ posted_at + ", created_at=" + created_at + ", likes=" + likes + ", img=" + img + "]";
	}
	

	
	
}
	