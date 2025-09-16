package kr.co.dong.member;

import java.sql.Date;

public class MemberDTO {
	private String id;
	private String password;
	private String name;
	private String email;
	private Date birth_date;
	private String gender;



	private String region;
	private String role;
	private int is_active;
	private String created_at;

	public MemberDTO() {
	}

	public String getGender() {
		return gender;
	}
	
	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getBirth_date() {
		return birth_date;
	}

	public void setBirth_date(Date birth_date) {
		this.birth_date = birth_date;
	}

	public String getRegion() {
		return region;
	}

	public void setRegion(String region) {
		this.region = region;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public int getIs_active() {
		return is_active;
	}

	public void setIs_active(int is_active) {
		this.is_active = is_active;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}

	public MemberDTO(String id, String password, String name, String email, Date birth_date, String gender,
			String region, String role, int is_active, String created_at) {
		super();
		this.id = id;
		this.password = password;
		this.name = name;
		this.email = email;
		this.birth_date = birth_date;
		this.gender = gender;
		this.region = region;
		this.role = role;
		this.is_active = is_active;
		this.created_at = created_at;
	}

	@Override
	public String toString() {
		return "MemberDTO [id=" + id + ", password=" + password + ", name=" + name + ", email=" + email
				+ ", birth_date=" + birth_date + ", gender=" + gender + ", region=" + region + ", role=" + role
				+ ", is_active=" + is_active + ", created_at=" + created_at + "]";
	}

	
}
