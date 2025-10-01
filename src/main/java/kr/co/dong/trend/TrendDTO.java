package kr.co.dong.trend;

import java.util.List;

public class TrendDTO {
	private String startDate;
	private String endDate;
	private String timeUnit;
	private List<TrendGroup> keywordGroups;
	private String device;
	private String gender;
	private List<String> ages;
	
	TrendDTO(){}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getTimeUnit() {
		return timeUnit;
	}

	public void setTimeUnit(String timeUnit) {
		this.timeUnit = timeUnit;
	}

	public List<TrendGroup> getKeywordGroups() {
		return keywordGroups;
	}

	public void setKeywordGroups(List<TrendGroup> keywordGroups) {
		this.keywordGroups = keywordGroups;
	}

	public String getDevice() {
		return device;
	}

	public void setDevice(String device) {
		this.device = device;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public List<String> getAges() {
		return ages;
	}

	public void setAges(List<String> ages) {
		this.ages = ages;
	}

	public TrendDTO(String startDate, String endDate, String timeUnit, List<TrendGroup> keywordGroups, String device,
			String gender, List<String> ages) {
		super();
		this.startDate = startDate;
		this.endDate = endDate;
		this.timeUnit = timeUnit;
		this.keywordGroups = keywordGroups;
		this.device = device;
		this.gender = gender;
		this.ages = ages;
	}

	@Override
	public String toString() {
		return "TrendDTO [startDate=" + startDate + ", endDate=" + endDate + ", timeUnit=" + timeUnit + ", device="
				+ device + ", gender=" + gender + ", ages=" + ages + "]";
	}

}