import React from 'react';

const SplitSection = ({ id, primarySlot, secondarySlot, reverseOrder }) => (
  <section id={id} className="py-300">
    <div
      data-sal="slide-up"
      data-sal-duration="700"
      data-sal-delay="0"
      data-sal-easing="ease"
      className="container mx-auto px-16 items-center flex flex-col lg:flex-row"
    >
      <div className="lg:w-1/2">{primarySlot}</div>
      <div
        className={`mb-10 mt-10 lg:mt-0 w-full lg:w-1/2 ${reverseOrder && `order-last lg:order-first`}`}
      >
        {secondarySlot}
      </div>
    </div>
  </section>
);

export default SplitSection;
