package kr.co.dong.deal;

import java.util.Date;

public class DealSummaryDTO {
	private int id;
	private String title;
	private String url;
	private int price;
	private String site;
	private Date postedAt;
	private Date createdAt;
	private int likes;
	private String img;

	public DealSummaryDTO() {
		// 기본 생성자 필수 (MyBatis 매핑 시 필요)
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
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

	public Date getPostedAt() {
		return postedAt;
	}

	public void setPostedAt(Date postedAt) {
		this.postedAt = postedAt;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public int getLikes() {
		return likes;
	}

	public void setLikes(int likes) {
		this.likes = likes;
	}

	public DealSummaryDTO(int id, String title, String url, int price, String site, Date postedAt, Date createdAt,
			int likes, String img) {
		super();
		this.id = id;
		this.title = title;
		this.url = url;
		this.price = price;
		this.site = site;
		this.postedAt = postedAt;
		this.createdAt = createdAt;
		this.likes = likes;
		this.img = img;
	}

	@Override
	public String toString() {
		return "DealSummaryDTO2 [id=" + id + ", title=" + title + ", url=" + url + ", price=" + price + ", site=" + site
				+ ", postedAt=" + postedAt + ", createdAt=" + createdAt + ", likes=" + likes + ", img=" + img + "]";
	}

}