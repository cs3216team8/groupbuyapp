class Buy {
  final String username;
  final String itemLink;
  final double amount;
  final int quantity;
  final String comment;

  Buy(
      this.username,
      this.itemLink,
      this.amount,
      this.quantity,
      [this.comment = '']
      );

  static Buy getDummyData() {
    return new Buy(
        "dawo",
        "https://www.amazon.sg/ASUS-VG27BQ-TUF-Gaming/dp/B07Z437T74?ref_=Oct_s9_apbd_omg_hd_bw_b71ZIJf&pf_rd_r=HNEDPN40Y917NSFMGQG6&pf_rd_p=364b9bf2-d790-5070-a722-fcf711fdcb6a&pf_rd_s=merchandised-search-10&pf_rd_t=BROWSE&pf_rd_i=6436118051",
        579,
        1,
    );
  }
}