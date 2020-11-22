import React from 'react';

const Footer = () => (
  <footer className="container mx-auto py-16 px-3 mt-48 mb-8 text-gray-800">
    <div className="flex -mx-3">
      <div className="flex-1 px-3">
        <h2 className="text-lg font-semibold">About Us</h2>
        <p className="mt-5">Made with love by the PiggyBuy team.</p>
      </div>
      <div className="flex-1 px-3">
        <h2 className="text-lg font-semibold">Important Links</h2>
        <ul className="mt-4 leading-loose">
          <li>
            <a href="https://www.termsfeed.com/live/153d8ff3-452f-4d2d-bec4-50b91f2a739a">Terms &amp; Conditions</a>
          </li>
          <li>
            <a href="https://www.termsfeed.com/live/a66ff0c0-b8d6-4ce6-81d6-ebaefe0ae69c">Privacy Policy</a>
          </li>
        </ul>
      </div>
      <div className="flex-1 px-3">
        <h2 className="text-lg font-semibold">Social Media</h2>
        <ul className="mt-4 leading-loose">
          <li>
            <a href="https://www.facebook.com/piggybuyapp">Facebook</a>
          </li>
          <li>
            <a href="https://www.instagram.com/piggybuy.app/">Instagram</a>
          </li>
        </ul>
      </div>
    </div>
  </footer>
);

export default Footer;
