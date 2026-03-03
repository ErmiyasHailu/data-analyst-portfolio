import pandas as pd
import matplotlib.pyplot as plt

# ----------------------------
# 1) Load data
# ----------------------------
df = pd.read_csv("NetFlix.csv")

# ----------------------------
# 2) Clean data
#    - Drop rows with missing values 
# ----------------------------
df_clean = df.dropna()

# ----------------------------
# 3) Core analysis 
# ----------------------------

# Counts
type_counts = df_clean["type"].value_counts()                 # Movie vs TV Show
rating_counts = df_clean["rating"].value_counts()             # rating distribution
year_counts = df_clean.groupby("release_year").size()         # titles per year
country_counts = df_clean["country"].value_counts()           # titles per country
genre_counts = df_clean["genres"].value_counts()              # titles per genre

# Numeric analysis
avg_duration_all = df_clean["duration"].mean()                # average duration overall
avg_duration_by_type = df_clean.groupby("type")["duration"].mean()  # avg duration by type

# ----------------------------
# 4) short "Insight Summary"
# ----------------------------
print("=== Netflix Data Analysis ( Summary) ===")
print(f"Rows before cleaning: {df.shape[0]:,} | after cleaning: {df_clean.shape[0]:,}")
print("\nMovies vs TV Shows:")
print(type_counts)

print("\nTop 10 Ratings:")
print(rating_counts.head(10))

print("\nTop 10 Countries:")
print(country_counts.head(10))

print(f"\nAverage duration (all titles): {avg_duration_all:.2f}")
print("\nAverage duration by type:")
print(avg_duration_by_type)

print("\nMost common genres (Top 10):")
print(genre_counts.head(10))

# ----------------------------
# 5) Charts (bar + line + pie = good mix)
#    - Also save charts as PNG for your GitHub portfolio
# ----------------------------

# Chart 1: Bar chart (Movie vs TV Show)
plt.figure()
type_counts.plot(kind="bar")
plt.title("Movies vs TV Shows")
plt.xlabel("Type")
plt.ylabel("Count")
plt.tight_layout()
plt.savefig("chart_type_bar.png", dpi=150)
plt.show()

# Chart 2: Pie chart (Movie vs TV Show) - mix style
plt.figure(figsize=(6, 6))
type_counts.plot(kind="pie", autopct="%1.1f%%")
plt.title("Movies vs TV Shows (Share)")
plt.ylabel("")  # remove the default y-label for cleaner look
plt.tight_layout()
plt.savefig("chart_type_pie.png", dpi=150)
plt.show()

# Chart 3: Line chart (Titles per year)
plt.figure()
year_counts.sort_index().plot(kind="line")
plt.title("Titles Released per Year")
plt.xlabel("Release Year")
plt.ylabel("Count")
plt.tight_layout()
plt.savefig("chart_year_line.png", dpi=150)
plt.show()

# Chart 4: Bar chart (Top 10 countries)
plt.figure()
country_counts.head(10).plot(kind="bar")
plt.title("Top 10 Countries by Number of Titles")
plt.xlabel("Country")
plt.ylabel("Count")
plt.tight_layout()
plt.savefig("chart_country_top10_bar.png", dpi=150)
plt.show()
